#! /bin/bash

# command line inputs
IN_SEQUENCE=$1      # input sequence (printf format)
F=$2                # first frame
L=$3                # last frame
OUT_SEQUENCE=$4     # output sequence (printf format)
DIR=${5:-"fwd"}     # direction (fwd/bwd)
PRMS=${6:-"1 0.25"} # optical flow parameters

# check correct number of input args
if [ "$#" -lt 4 ]; 
then
	echo "Usage: $0 input-seq first-frame last-frame output-seq [fwd/bwd] [params]" >&2
	exit 1
fi

# create output folder
OUT_DIR=$(dirname $OUT_SEQUENCE)
mkdir -p $OUT_DIR

echo "Computing $DIR optical flow for sequence $IN_SEQUENCE. Output stored in $OUT_SEQUENCE."

# parse optical flow parameters
read -ra O <<< "$PRMS"
FSCALE=${O[0]}  # finest scale (0 = input resolution, 1 = half resolution, etc.)
DW=${O[1]}      # data attachment weight (0.1 ~ very smooth 0.2 ~ noisy)
NPROC=2         # number of parallel threads (OpenMP)

# nproc tau lambda theta nscales fscale zfactor nwarps epsilon verbos
OFPRMS="$NPROC 0 $DW 0 0 $FSCALE";

TVL1="src/3_oflow/tvl1flow_3/tvl1flow"
if [[ $DIR == "fwd" ]]
then

	# compute forward flow
	for i in $(seq $F $((L - 1)));
	do
		$TVL1 $(printf $IN_SEQUENCE $i) $(printf $IN_SEQUENCE $((i + 1))) \
				$(printf $OUT_SEQUENCE $i) $OFPRMS
	done

elif [[ $DIR == "bwd" ]]
then

	# compute backward flow
	for i in $(seq $((F + 1)) $L);
	do
		$TVL1 $(printf $IN_SEQUENCE $i) $(printf $IN_SEQUENCE $((i - 1))) \
				$(printf $OUT_SEQUENCE $i) $OFPRMS
	done

else

	echo "ERROR: Wrong direction $DIR" >&2
	exit

fi
