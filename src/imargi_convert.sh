#!/usr/bin/env bash
PROGNAME=$0

usage() {
    cat << EOF >&2
    Usage: $PROGNAME [-f <file_format>] [-k <keep_cols>] [-b <bin_size>] [-i <input_file>] [-o <output_file>] 

    Dependency: gzip, awk, cool
    This script can convert .pairs format to BEDPE, .cool, and GIVE interaction format.
    -f : The target format, only accept 'cool', 'bedpe' and 'give'. For 'cool', it will generate
         a ".cool" file with defined resolution of -b option and a multi-resolution ".mcool" file
         based on the ".cool" file. For 'bedpe', the output will be pbgzip compressed file. So
         keep in mind to name the output_file '-o' with '.gz' extesion.
    -k : Keep extra information column in BEDPE. Columns ids in .pairs file you want to keep.
         For example, 'cigar1,cigar2'. Default value is "", i.e., drop all extra cols.
    -b : bin size for cool format. Default is 5000.
    -i : Input file.
    -o : Output file.
    -h : Show usage help
EOF
    exit 1
}

while getopts :f:k:b:i:o:h opt; do
    case $opt in
        f) format=${OPTARG};;
        k) keep_cols=${OPTARG};;
        b) bin_size=${OPTARG};;
        i) input_file=${OPTARG};;
        o) output_file=${OPTARG};;
        h) usage;;
    esac
done

[ -z "$keep_cols" ] && keep_cols=""
[ -z "$bin_size" ] && bin_size=5000
[ ! -f "$input_file" ] && echo "Error!! Input file not exist: "$input_file && usage
[ -f "$output_file" ] && echo "Error!! Output file already exist: "$output_file && usage

if [ "$format" == "bedpe" ]; then
    echo ">>>>>>>>> Start: Convert .pairs format $input_file to BEDPE format $output_file ..."
    date
    zcat $input_file | \
        awk  -v keep_cols="$keep_cols" 'BEGIN{OFS="\t"}{
            if(NR % 1000000 == 0){print NR" records processed ..." > "/dev/stderr" }
            if($1 == "#columns:"){
                header="#chrom1\tstart1\tend1\tchrom2\tstart2\tend2\tname\tscore\tstrand1\tstrand2";
                split(keep_cols, arr_keep, ",");
                for(i=9;i<=NF;i++){
                    kflag=0;
                    for(key in arr_keep){
                        if($i==arr_keep[key]){
                            kflag=1;
                            break;
                        };
                    };
                    if(kflag==1){
                        extra_cols[i-1]=$i;
                        header=header"\t"$i;
                    }else{
                        continue;
                    };
                };
                print header;
                next;
            };
            if(!($0 ~ /^#/)){
                type_n1=split(gensub("[0-9]+", "", "g", $11), type1, "");
                val_n1=split($11, val1, "[A-Z=]"); 
                m_flag=0; m_index=0;
                for(i=1;i<=type_n1;i++){
                    if(type1[i] ~ /[M=XND]/){
                        if(m_flag==0){
                            m_flag=1; 
                            m_index+=1;
                            mval1[m_index]=val1[i];
                        }else{
                            mval1[m_index]+=val1[i];
                        };
                    }else{
                        if(type1[i] ~ /[SH]/){
                            m_flag=0;
                        };
                    };
                };
                type_n2=split(gensub("[0-9]+", "", "g", $12), type2, "");
                val_n2=split($12, val2, "[A-Z=]");
                m_flag=0; m_index=0;
                for(i=1;i<=type_n2;i++){
                    if(type2[i] ~ /[M=XND]/){
                        if(m_flag==0){
                            m_flag=1;
                            m_index+=1;
                            mval2[m_index]=val2[i];
                        }else{
                            mval2[m_index]+=val2[i];
                        };
                    }else{
                        if(type2[i] ~ /[SH]/){
                            m_flag=0;
                        };
                    };
                };
                if($6=="+"){
                    start1 = $3-1; end1 = start1 + mval1[1];
                }else{
                    end1 = $3; start1 = end1 - mval1[length(mval1)];
                };
                if($7=="+"){
                    start2 = $5 - 1; end2 = start2 + mval2[1];
                }else{
                    end2=$5; start2 = end2 - mval2[length(mval2)];
                };
                extra_info="";
                for(i in extra_cols){
                    if(extra_info==""){
                        extra_info=$i; 
                    }else{
                        extra_info=extra_info"\t"$i
                    };
                };
                print $2, start1, end1, $4, start2, end2, $1, 1, $6, $7, extra_info;
            }
        }' |pbgzip -t 0 -c >$output_file
fi

if [ "$format" == "give" ]; then
    echo ">>>>>>>>> Start: Convert .pairs format $input_file to GIVE interaction format $output_file ..."
    date
    zcat $input_file | \
        awk  -v drop_cols="$drop_cols" 'BEGIN{OFS="\t"; count=1;}{
            if(NR % 1000000 == 0){print NR" records processed ..." > "/dev/stderr" }
            if(!($0 ~ /^#/)){
                type_n1=split(gensub("[0-9]+", "", "g", $11), type1, "");
                val_n1=split($11, val1, "[A-Z=]"); 
                m_flag=0; m_index=0;
                for(i=1;i<=type_n1;i++){
                    if(type1[i] ~ /[M=XND]/){
                        if(m_flag==0){
                            m_flag=1; 
                            m_index+=1;
                            mval1[m_index]=val1[i];
                        }else{
                            mval1[m_index]+=val1[i];
                        }
                    }else{
                        if(type1[i] ~ /[SH]/){
                            m_flag=0;
                        }
                    }
                };
                type_n2=split(gensub("[0-9]+", "", "g", $12), type2, "");
                val_n2=split($12, val2, "[A-Z=]");
                m_flag=0; m_index=0;
                for(i=1;i<=type_n2;i++){
                    if(type2[i] ~ /[M=XND]/){
                        if(m_flag==0){
                            m_flag=1;
                            m_index+=1;
                            mval2[m_index]=val2[i];
                        }else{
                            mval2[m_index]+=val2[i];
                        }
                    }else{
                        if(type2[i] ~ /[SH]/){
                            m_flag=0;
                        }
                    }
                };
                if($6=="+"){
                    start1 = $3-1; end1 = start1 + mval1[1];
                }else{
                    end1 = $3; start1 = end1 - mval1[length(mval1)];
                };
                if($7=="+"){
                    start2 = $5 - 1; end2 = start2 + mval2[1];
                }else{
                    end2=$5; start2 = end2 - mval2[length(mval2)];
                };
                print count, $2, start1, end1, $1, 1, 0;
                count+=1;
                print count, $4, start2, end2, $1, 1, 1;
                count+=1;
            }
        }' >$output_file
fi

if [ "$format" == "cool" ]; then
    echo ">>>>>>>>> Start: Convert .pairs format $input_file to cool format $output_file in $bin_size resolution ..."
    date
    chrom_size="chromsize."$RANDOM

    zcat $input_file | awk 'BEGIN{OFS="\t"}{if($0 !~ /^#/){exit;}; if($0 ~/^#chromsize/){print $2, $3};}' > $chrom_size

    cooler cload pairs --asymmetric --chrom1 2 --pos1 3 --chrom2 4 --pos2 5 \
        $chrom_size:$bin_size $input_file $output_file
    cooler zoomify $output_file
    rm $chrom_size
fi

date
echo "<<<<<<<<<< Finished: conversion."