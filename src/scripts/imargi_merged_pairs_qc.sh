#!/usr/bin/env bash
PAIRS_STATS=$2
OUTDIR=$3

if [ ! -d "$OUTDIR" ]
then
  mkdir $OUTDIR
fi

python3 /usr/local/bin/get_merged_pairs_qc.py $PAIRS_STATS $OUTDIR
