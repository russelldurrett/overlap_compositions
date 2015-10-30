# overlap_compositions


This is a snakemake-based pipeline to take overlapping fastq reads to per-base nulceotide compositions. 

Steps: 
Trim Adapters Read 1 and Read 2
Align overlapping reads and calculate consensus 
Discard sequences highly dissimilar to target 
Calculate per-base compositions 


