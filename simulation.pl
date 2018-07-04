open(g,"chromatin.fasta");    ## input file1: the sequences of the chromatins or contigs
while(<g>)
{
	chomp;
	chop;
	if(grep(/>/,$_))
	{
		@token=split(/\s/,$_);
		@token1=split(/>/,$token[0]);
		$chr=$token1[1];
		$n=$chr;
		$hash{$n}=0;
	}
	if(!grep(/>/,$_))
	{
		$seq{$n}=$seq{$n}.$_;
	}
}
close(g);

open(l,"lnc_length.txt");   ## input file2: the length of the predicted lncRNAs
while(<l>)
{
	chomp;
	@token=split(/\t/,$_);
	$len{$token[0]}=$token[1];
}
close(l);

open(sm,"noncoding.gtf.info.txt");   ## input file3: the location of the noncoding regions
open(res,">simulated_lncRNAs.fasta");   ## output file: the sequences of the simulated lncRNAs
while(<sm>)
{
	chomp;
	@token=split(/\t/,$_);
	$c=$token[2];
	$gid=$token[0];
	if(exists($seq{$c}))
	{
	$va=$seq{$c};
	@token1=split(//,$va);
	$num=scalar @token1;
	print res ">".$token[0]."\n";
	LOOP:
	$ss=int(rand($num));
	$ee=$ss+$len{$gid}; 
	if(($ee gt $num))
	{
		goto LOOP;
	}else{
		for($a=$ss;$a<$ee;$a++)
		{
		print res $token1[$a];
		}
	}
	print res "\n";
	}
}
close(res);
close(sm);