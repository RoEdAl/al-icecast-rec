#!/bin/bash -e

# commands
readonly ARECORD_CMD="arecord -q -M -N -t raw -D ${AUDIO_DEVICE:-hw:} -c 2 -r ${AUDIO_SAMPLE_RATE:-48000} -f ${ARECORD_FORMAT:-S16_LE}"
readonly FFMPEG_PRE="ffmpeg -hide_banner -loglevel repeat+error -f ${FFMPEG_FORMAT:-s16le} -ac 2 -ar ${AUDIO_SAMPLE_RATE:-48000} -i -"

# params
readonly OPUS_PARAMS="-b:a ${OPUS_BITRATE:-96k} -vbr constrained -packet_loss ${OPUS_PACKET_LOSS:-5}"
readonly FLAC_PARAMS='-compression_level 0 -lpc_coeff_precision 1 -lpc_type none -lpc_passes 1 -prediction_order_method estimation -ch_mode indep'

declare -r -a ICE_SOURCE=(
    -content_type 'application/ogg'
    -ice_name "${SOURCE_NAME:-Live Stream}"
    -ice_description "${SOURCE_DESCRIPTION:-Opus codec}"
    "icecast://source:${PWD_SOURCE:-source}@[::1]:${SERVER_PORT:-50000}/live")

declare -r -a HD_ICE_SOURCE=(
    -content_type 'application/ogg'
    -ice_name "${HD_SOURCE_NAME:-Live Stream HD}"
    -ice_description "${HD_SOURCE_DESCRIPTION:-FLAC codec}"
    "icecast://source:${PWD_SOURCE:-source}@[::1]:${SERVER_PORT:-50000}/live-hd")

case $1 in
    opus)
    $ARECORD_CMD | $FFMPEG_PRE -f ogg -c:a libopus $OPUS_PARAMS "${ICE_SOURCE[@]}"
    ;;

    flac)
    $ARECORD_CMD | $FFMPEG_PRE -f ogg -c:a flac $FLAC_PARAMS "${HD_ICE_SOURCE[@]}"
    ;;

    both)
    $ARECORD_CMD | $FFMPEG_PRE \
        -filter_complex '[0:a] asplit=2 [in1][iin2]; [iin2] aformat=sample_fmts=s16 [in2]' \
        -map '[in1]' -f ogg -c:a libopus $OPUS_PARAMS "${ICE_SOURCE[@]}" \
        -map '[in2]' -f ogg -c:a flac $FLAC_PARAMS "${HD_ICE_SOURCE[@]}"
    ;;

    *)
    echo 'Invalid parameter'
    exit 1
    ;;
esac
