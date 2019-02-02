#!/bin/bash

set -e

INBASE="$1"

if [[ "$INBASE" = "" ]]; then
    echo "Usage: $0 <base filepath>"
    exit 1
fi

#
#
#
VERTF="${INBASE}_vertices.inc"
VERTNF="${INBASE}_normals.inc"
FACEF="${INBASE}_faces.inc"

(
    echo "s 1"
    echo "g model"
    echo "s 1"
    sed "s/^/v/;s/[,<]/ /g;s/>//" "${VERTF}"
    echo
    sed "s/^/vn/;s/[,<]/ /g;s/>//" "${VERTNF}"
    echo
    sed "s/^/f/;s/[,<]/ /g;s/>//" "${FACEF}"
    echo
) > "${INBASE}_object".obj
