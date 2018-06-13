#!/bin/bash -e

readonly -a ARECORD_PARAMS=(-q -M -N -t raw -D ${AUDIO_DEVICE:-hw:} -c 2 -r ${AUDIO_SAMPLE_RATE:-48000} -f ${AUDIO_FORMAT_ARECORD:-S16_LE})
readonly -a FFMPEG_PRE=(-hide_banner -loglevel repeat+error -f ${AUDIO_FORMAT_FFMPEG:-s16le} -ac 2 -ar ${AUDIO_SAMPLE_RATE:-48000} -i -)
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

case $1 in
    opus)
    arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}"
    ;;

    flac)
    arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
    ;;

    both)
    arecord "${ARECORD_PARAMS[@]}" | ffmpeg "${FFMPEG_PRE[@]}" \
        -filter_complex '[0:a] asplit=2 [in1][iin2]; [iin2] aformat=sample_fmts=s16 [in2]' \
        -map '[in1]' -f ogg -page_duration 1 -serial_offset $SERIAL_OPUS -c:a libopus "${OPUS_PARAMS[@]}" "${ICE_SOURCE[@]}" \
        -map '[in2]' -f ogg -page_duration 1 -serial_offset $SERIAL_FLAC -c:a flac "${FLAC_PARAMS[@]}" "${HD_ICE_SOURCE[@]}"
    ;;

    *)
    echo 'Invalid parameter'
    exit 1
    ;;
esac
