#!/usr/bin/perl
#Written by Yong Wu
#2021-04-25
$dir = "/home/wuyong/data/phs001900/data/*1.fastq.gz";
@files = glob( $dir );

my %read1;
my %read2;

foreach (@files){
	$_ =~ s/\/home\/wuyong\/data\/phs001900\/data\///;
	my $r2 = $_ =~ s/_1\.fastq\.gz/_2\.fastq\.gz/r;
	$_ =~ m/(.*?)\-.*_1\.fastq\.gz/;
	if(!exists $read1{$1}){
		$read1{$1} = $_;
		$read2{$1} = $r2;
	}
	else{
		$read1{$1} = $read1{$1}.",$_";
		$read2{$1} = $read2{$1}.",$r2";
	}
}

print "#!/bin/bash\n";
print "#Written by Yong Wu\n";
print "#2021-04-25\n";
foreach $key (sort keys %read1){
print "
cd /home/wuyong/data/phs001900/data
/home/wuyong/software/STAR-2.7.6a/bin/Linux_x86_64/STAR \\
--runThreadN 10 \\
--genomeDir /home/wuyong/genome/gencode_hg38 \\
--readFilesIn $read1{$key} $read2{$key} \\
--readFilesCommand zcat \\
--sjdbGTFfile /home/wuyong/genome/gencode_hg38/gencode.v35.annotation.gtf \\
--sjdbOverhang 49 \\
--outFileNamePrefix /home/wuyong/data/phs001900/star/$key\_ \\
--outSAMtype BAM SortedByCoordinate \\
--outFilterType BySJout \\
--outFilterMultimapNmax 20 \\
--alignSJoverhangMin 8 \\
--alignSJDBoverhangMin 1 \\
--outFilterMismatchNmax 999 \\
--outFilterMismatchNoverReadLmax 0.04 \\
--alignIntronMin 20 \\
--alignIntronMax 1000000 \\
--alignMatesGapMax 1000000

cd /home/wuyong/data/phs001900/star
samtools index $key\_Aligned.sortedByCoord.out.bam

cd /home/wuyong/data/phs001900/junction
regtools junctions extract -s 1 -m 20 -M 1000000 -o $key\_regtools_star.bed /home/wuyong/data/phs001900/star/$key\_Aligned.sortedByCoord.out.bam
bed_to_juncs <$key\_regtools_star.bed >$key\_regtools.count

cd /home/wuyong/data/phs001900/featurecount
featureCounts -O -T 10 -f -t exon -a /home/wuyong/genome/gencode_hg38/gencode.v35.annotation.gtf -o $key\_Exon.count /home/wuyong/data/phs001900/star/$key\_Aligned.sortedByCoord.out.bam
featureCounts -T 10 -a /home/wuyong/genome/gencode_hg38/gencode.v35.annotation.gtf -o $key\_Gene.count /home/wuyong/data/phs001900/star/$key\_Aligned.sortedByCoord.out.bam
";
}
