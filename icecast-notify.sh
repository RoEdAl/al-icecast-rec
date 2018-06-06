#!/bin/bash -e

SCRIPT_NAME="${0/*\//}"
SCRIPT_NAME=${SCRIPT_NAME%.sh}
ACTION=${SCRIPT_NAME#icecast-on-}

logger -t icecast-rec $ACTION: $@
