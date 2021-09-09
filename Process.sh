#!/bin/bash
cd /home/wuyong/data/phs001900/script
#decompressing the sra file with fastq-dump
bash FastqDump.sh

#produce the junction count bash
perl count_junction.pl > count_junction.sh

nohup bash count_junction.sh >count_junction.out 2>count_junction.err &

perl compare_junction.pl >merge_junction.bed

bedtools sort -i merge_junction.bed >merge_junction_sort.bed

regtools junctions annotate -S -o merge_junction_sort.ann merge_junction_sort.bed /home/wuyong/genome/gencode_hg38/GRCh38.primary_assembly.genome.fa /home/wuyong/genome/gencode_hg38/gencode.v35.annotation.gtf

cut -d "," -f 9 /home/wuyong/data/phs001900/script/SraRunTable.txt | sed 's/\-.*//g' | sed '1d' | sort -u >sample.list

python3 MergeJunction.py /home/wuyong/data/phs001900/result/merge_junction_sort.bed sample.list ../result/merge_junction.count

for i in `cat sample.list`;do sed 's/\s\+/\t/g' ../star/${i}_Log.final.out | awk -vFS="\t" -vOFS="\t" '{if(NR==9){maprate=$7;}else if(NR==10){print "'$i'",maprate,$7;}}';done | sed '1i Sample\tUniqueMappedReads\tUniqueMappedRate' >STAR_Map_Info.txt
