#!/usr/bin/env bash
PIPELINE_STATS=$1
PAIRS_STATS=$2
OUTDIR=$3

if [ ! -d "$OUTDIR" ]
then
  mkdir $OUTDIR
fi

python3 /usr/local/bin/get_qc.py $PIPELINE_STATS $PAIRS_STATS $OUTDIR
