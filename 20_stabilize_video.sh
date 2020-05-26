#! /bin/bash

# command line inputs
IN_SEQUENCE=$1     # input sequence (printf format)
F=$2               # first frame
L=$3               # last frame
OUT_SEQUENCE=$4    # output sequence (printf format)
PRMS=${5:-""}      # parameters

echo $PRMS

# check correct number of input args
if [ "$#" -lt 4 ]; 
then
	echo "Usage: $0 input-seq first-frame last-frame output-seq [params]" >&2
	exit 1
fi

OUT_DIR=$(dirname $OUT_SEQUENCE)
TRANS_FILE="$OUT_DIR/stab-transforms.txt"

echo "Stabilizing sequence $IN_SEQUENCE stored in $OUT_SEQUENCE."
echo "Transformation parameters stored in $TRANS_FILE."

# create output folder
mkdir -p $OUT_DIR

STABI="src/2_stabilization/estadeo_1.1/bin/estadeo"
$STABI $IN_SEQUENCE $F $L -1 -1 -1 $PRMS -o $OUT_SEQUENCE -w $TRANS_FILE

