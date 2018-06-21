#!/bin/bash -e

echoerr() {
    echo "$@" 1>&2
}

make_pattern() {
    local FRAME_SIZE=$((${AUDIO_SAMPLE_RATE:-48000} / 400))
    case $1 in
        busy-tone)
        systemd-notify --status="Generating pattern: $1"
        ffmpeg -y -hide_banner -loglevel repeat+error \
            -f lavfi -i "sine=frequency=480:sample_rate=${AUDIO_SAMPLE_RATE:-48000}:duration=2:samples_per_frame=${FRAME_SIZE},volume=10dB" \
            -f lavfi -i "sine=frequency=620:sample_rate=${AUDIO_SAMPLE_RATE:-48000}:duration=2:samples_per_frame=${FRAME_SIZE},volume=10dB" \
            -filter_complex '[0:a][1:a] amerge=inputs=2 , aeval=if(eq(round(t/2)\,ceil(t/2))\,val(0)\,-val(1))|if(eq(round(t/2)\,ceil(t/2))\,val(1)\,-val(0)) , aeval=if(eq(round(t)\,ceil(t))\,val(ch)\,(random(0)-0.5)*0.04)|if(eq(round(t)\,ceil(t))\,val(ch)\,(random(1)-0.5)*0.04) [out]' \
            -map '[out]' -c:a pcm_s32le ${PATTERN_FILE}
        ;;

        white-noise)
        systemd-notify --status="Generating pattern: $1"
        ffmpeg -y -hide_banner -loglevel repeat+error \
            -f lavfi -i "aevalsrc=(random(0)-0.5)*0.07|(random(1)-0.5)*0.07:sample_rate=${AUDIO_SAMPLE_RATE:-48000}:duration=2:nb_samples=${FRAME_SIZE}" \
            -c:a pcm_s32le ${PATTERN_FILE}
        ;;

        *)
        echoerr "Invalid pattern: $1"
        return 1
        ;;
    esac
}

[[ -z ${AUDIO_PATTERN} ]] || {
    readonly PATTERN_FILE='/run/icecast-rec-source/pattern.mka'
    make_pattern ${AUDIO_PATTERN}
}

readonly -a OPUS_PARAMS=(-b:a ${OPUS_BITRATE:-96k} -compression_level 0 -vbr constrained -packet_loss ${OPUS_PACKET_LOSS:-5} -frame_duration 10)
readonly -a FLAC_PARAMS=(-compression_level 0 -lpc_coeff_precision 1 -lpc_type none -lpc_passes 1 -prediction_order_method estimation -ch_mode indep)

readonly SERIAL_OPUS=100
readonly SERIAL_FLAC=101

readonly -a ICE_SOURCE=(
    -content_type 'application/ogg'
    -ice_name "${LB_SOURCE_NAME:-Live Stream}"
    -ice_description "${LB_SOURCE_DESCRIPTION:-Opus codec}"
    -ice_genre "${SOURCE_GENRE:-unspecified}"
    -user_agent "${SOURCE_USER_AGENT}"
    "icecast://source:${PWD_SOURCE:-source}@[::1]:${SERVER_PORT:-50000}/live")

readonly -a HD_ICE_SOURCE=(
    -content_type 'application/ogg'
    -ice_name "${HD_SOURCE_NAME:-Live Stream HD}"
    -ice_description "${HD_SOURCE_DESCRIPTION:-FLAC codec}"
    -ice_genre "${SOURCE_GENRE:-unspecified}"
    -user_agent "${SOURCE_USER_AGENT}"
    "icecast://source:${PWD_SOURCE:-source}@[::1]:${SERVER_PORT:-50000}/live-hd")

if [[ -z ${AUDIO_PATTERN} ]]; then
    readonly -a ARECORD_PARAMS=(-q -M -N -t raw -D ${AUDIO_DEVICE:-hw:} -c 2 -r ${AUDIO_SAMPLE_RATE:-48000} -f ${AUDIO_FORMAT_ARECORD:-S16_LE})
    readonly -a FFMPEG_PRE=(-hide_banner -loglevel repeat+error -f ${AUDIO_FORMAT_FFMPEG:-s16le} -ac 2 -ar ${AUDIO_SAMPLE_RATE:-48000} -i -)

    case $1 in
        opus)
        systemd-notify --ready --status="Sending Ogg/Opus stream [${AUDIO_DEVICE:-hw:}]"
        arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}"
        ;;

        flac)
        systemd-notify --ready --status="Sending Ogg/Flac stream [${AUDIO_DEVICE:-hw:}]"
        arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
        ;;

        both)
        systemd-notify --ready --status="Sending Ogg/Opus + Ogg/Flac stream [${AUDIO_DEVICE:-hw:}]"
        arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" \
            -filter_complex '[0:a] asplit=2 [in1][iin2]; [iin2] aformat=sample_fmts=s16 [in2]' \
            -map '[in1]' -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}" \
            -map '[in2]' -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
        ;;

        *)
        echoerr "Invalid profile: $1"
        exit 1
       ;;
    esac
else
    readonly -a FFMPEG_PRE=(-hide_banner -loglevel repeat+error -re -fflags +genpts -stream_loop -1 -i "${PATTERN_FILE}")

    case $1 in
         opus)
         systemd-notify --ready --status="Sending Ogg/Opus stream [${AUDIO_PATTERN}]"
         ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}"
         ;;

         flac)
         systemd-notify --ready --status="Sending Ogg/Flac stream [${AUDIO_PATTERN}]"
         ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
         ;;

         both)
         systemd-notify --ready --status="Sending Ogg/Opus + Ogg/Flac stream [${AUDIO_PATTERN}]"
         ffmpeg "${FFMPEG_PRE[@]}" \
             -filter_complex '[0:a] asplit=2 [in1][iin2]; [iin2] aformat=sample_fmts=s16 [in2]' \
             -map '[in1]' -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}" \
             -map '[in2]' -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
         ;;

         *)
         echoerr "Invalid profile: $1"
         exit 1
        ;;
     esac
fi
