#!/usr/bin/perl
#Written by Yong Wu
#2021-04-27

$dir = "/home/wuyong/data/phs001900/junction/*_regtools.count";
@files = glob( $dir );

my %id;
my $n = 1;
foreach (@files){
	open IN, $_ or die;
	while(<IN>){
		chomp;
		my @a = split(/\t/, $_);
		if(exists $id{$a[0]}{$a[1]}{$a[2]}{$a[3]}){
			next;
		}
		else{
			my $junction_number = sprintf("%0*d", 8, $n);
			my $junction_name = "JUNC".$junction_number;
#			"chr	start	end	junction_name	1	strand	start	end	255,0,0	2	1,-2	0,end+1-start";
			my $ems = $a[2] - 1 - $a[1];
			print "$a[0]\t$a[1]\t$a[2]\t$junction_name\t1\t$a[3]\t$a[1]\t$a[2]\t255,0,0\t2\t1,2\t0,$ems\n";
			$id{$a[0]}{$a[1]}{$a[2]}{$a[3]} = 0;
			$n++;
		}
	}
	close IN;
}