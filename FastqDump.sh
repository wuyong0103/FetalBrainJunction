#!/bin/bash
cd /home/wuyong/ncbi/dbGaP-25691
for i in `cut -d "," -f 1,9 /home/wuyong/data/phs001900/script/SraRunTable.txt | sed '1d'`
do
  OLD_IFS="$IFS"
  IFS=","
  arr=(${i})
  IFS="$OLD_IFS"
  fastq-dump --split-3 --gzip --outdir /home/wuyong/data/phs001900/data /home/wuyong/data/phs001900/data/${arr[0]}_dbGaP-25691.sra
  mv /home/wuyong/data/phs001900/data/${arr[0]}_dbGaP-25691_1.fastq.gz /home/wuyong/data/phs001900/data/${arr[1]}_1.fastq.gz
  mv /home/wuyong/data/phs001900/data/${arr[0]}_dbGaP-25691_2.fastq.gz /home/wuyong/data/phs001900/data/${arr[1]}_2.fastq.gz
done
