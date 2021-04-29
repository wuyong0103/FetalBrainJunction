#!/usr/bin/env python3
# -*- encoding:utf-8 -*-
# Written by Yong Wu!
# 2021-04-29
# python3 MergeJunction.py /home/wuyong/data/phs001900/result/merge_junction_sort.bed sample.list ../result/merge_junction.count

import sys

def GetName(bedfile):
    """
    get the junction name from merge_junction_sort.bed
    """
    bed = {}
    with open(bedfile, 'r') as f:
        lines = f.readlines()
    for line in lines:
        content = line.strip().split('\t')
        #key = "chr_start_end_strand"
        key = content[0] + "_" + content[1] + "_" + content[2] + "_" + content[5]
        bed[key] = content[3]
    return bed

def MergeCount(bed, dir, samplefile, outputfile):
    """
    Merge all the junction count into one file
    """
    bed["sample"] = "name"
    with open(samplefile, 'r') as f:
        lines = f.readlines()
    for line in lines:
        count = {}
        line = line.strip()
        filename = dir + line + "_regtools.count"
        #get the table header
        bed["sample"] = bed["sample"] + "\t" + line
        with open(filename, 'r') as ff:
            fflines = ff.readlines()
        for ffline in fflines:
            content = ffline.strip().split('\t')
            key = content[0] + "_" + content[1] + "_" + content[2] + "_" + content[3]
            count[key] = content[4]
        for bkey in bed.keys():
            if bkey in count.keys():
                bed[bkey] = bed[bkey] + "\t" + str(count[bkey])
            elif bkey == "sample":
                continue
            else:
                bed[bkey] = bed[bkey] + "\t0"
    
    with open(outputfile, 'w') as w:
        w.write("{}\n".format(bed["sample"]))
        for bkey in bed.keys():
            w.write("{}\n".format(bed[bkey]))

def main():
    bed = GetName(sys.argv[1])
    MergeCount(bed, "/home/wuyong/data/phs001900/junction/", sys.argv[2], sys.argv[3])

if __name__ == "__main__":
    main()