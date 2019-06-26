#!/usr/bin/env bash
PIPELINE_STATS=$1
PAIRS_STATS=$2
OUTDIR=$3

if [ ! -d "$OUTDIR" ]
then
  mkdir $OUTDIR
fi

mkfifo pipeline_stats_tmp
mkfifo pairs_stats_tmp1
mkfifo pairs_stats_tmp2
mkfifo pairs_stats_tmp1_final
mkfifo pairs_stats_tmp2_final
head -7 $PIPELINE_STATS > pipeline_stats_tmp.txt
head -5 $PAIRS_STATS> pairs_stats_tmp1.txt
tail -3 pairs_stats_tmp1.txt > pairs_stats_tmp1_final.txt
tail -4 $PAIRS_STATS > pairs_stats_tmp2.txt
head -3 pairs_stats_tmp2.txt > pairs_stats_tmp2_final.txt

cat pipeline_stats_tmp.txt pairs_stats_tmp1_final.txt pairs_stats_tmp2_final.txt > $OUTDIR/qc_report.txt
rm pipeline_stats_tmp*
rm pairs*
