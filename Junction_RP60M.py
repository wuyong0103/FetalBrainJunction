#!/usr/bin/env python3
# -*- encoding:utf-8 -*-
# Written by Yong Wu!
# 2021-04-30
# Happy Labor Day, Yeah! Yeah!

import sys

def GetTotalMapped(file):
    """
    Get the total mapped reads
    """
    totalmap = {}
    with open(file, "r") as f:
        lines = f.readlines()
    for line in lines[1:]:
        content = line.strip().split('\t')
        #content
        #Sample TotalMappedReads    UniqueMappedRate
        #Fileter samples with UniqueMappedRate < 70
        if(float(content[2]) > 70):
            key = content[0]
            totalmap[key] = content[1]
    return totalmap

def DropJunction(file):
    """
    Filter junctions with expressed (junction reads > 2) less than 4 samples
    """
    junction_dict = {}
    with open(file, 'r') as f:
        lines = f.readlines()
    junction_dict["name"] = lines[0]
    for line in lines[1:]:
        content = line.strip().split('\t')
        jg2 = 0
        for junction in content[1:]:
            if(int(junction) > 2):
                jg2 = jg2 + 1
        if(jg2 > 3):
            junction_dict[content[0]] = content[1:]
    return junction_dict

def RP60M(totalreads, jdict, outfile):
    """
    Calculate junction expression RP60M
    """
    with open(outfile, 'w') as w:
        w.write("{}".format(jdict["name"]))
        for junction in jdict.keys():
            if(junction != "name"):
                w.write("{}".format(junction))
                for i in jdict[junction]:
                    rp60m = i*60000000/totalreads[junction]
                    w.write("\t{}".format(rp60m))
                w.write("\n")

def main():
    totalmap = GetTotalMapped(sys.argv[1])
    jdict = DropJunction(sys.argv[2])
    RP60M(totalmap, jdict, sys.argv[3])

if __name__ == "__main__":
    main()
