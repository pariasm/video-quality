#! /bin/bash

# command line inputs
IN_SEQUENCE=$1 # path to input sequence (printf format)
F=$2           # first frame (optional: default 1)
L=$3           # last frame  (optional: default all frames)
OUT_FOLDER=$4  # output folder

# parameters of preprocessing
REMOVE_OUTLIERS=${5:-0}  # FIXME - deprecated
REMOVE_FPN=${6:-0}       # FIXME - deprecated

# toggle deblurring
DEBLUR=${7:-0}

# check correct number of input args
if [ "$#" -lt 4 ]; 
then
	echo "Usage: $0 sequence-path first-frame last-frame output-folder" >&2
	echo "See source for more command line options."
	exit 1
fi


echo "Running full pipeline for sequence $IN_SEQUENCE"

# stabilize sequence using affinities (-t 6)
STAB_SEQ="$OUT_FOLDER/stab-t6/%05d.png"
./20_stabilize_video.sh $IN_SEQUENCE $F $L $STAB_SEQ "-t 6"

# compute forward optical flow with default parameters
OFLOW_SEQ="$OUT_FOLDER/tvl1flow/%05d.flo"
./30_compute_tvl1_flow.sh $STAB_SEQ $F $L $OFLOW_SEQ "fwd"

if [ $DEBLUR -eq 1 ];
then
	# TODO
	./50_run_deblurring.sh $SEQUENCE $F $L "kalman"
	./50_run_deblurring.sh $SEQUENCE $F $L "rbilf"
fi

