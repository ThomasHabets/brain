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
    sed "s/^/v/;s/[,<]/ /g;s/>//" "${VERTF}"
    sed "s/^/vn/;s/[,<]/ /g;s/>//" "${VERTNF}"
    sed "s/^/f/;s/[,<]/ /g;s/>//" "${FACEF}"
) > "${INBASE}_object".obj
