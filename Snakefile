
import os, sys 

from collections import defaultdict
def tree(): return defaultdict(tree)

try:
  config["R1"]
except KeyError: 
  read1_filename = "C.R1.fastq"
else:
  read1_filename = config["R1"]

try:
  config["R2"]
except KeyError: 
  read2_filename = "C.R2.fastq"
else:
  read2_filename = config["R2"]


outbase = read1_filename.replace('.fq', '').replace('.fastq', '')
outbase = 'C'
pandaseq_algorithms = 'ea_util', 'flash', 'pear', 'rdp_mle', 'simple_bayesian', 'stitch', 'uparse'

rule all: 
  input: outbase + ".base_compositions.txt"


rule pandaseq_algs: 
  input:  outbase + '.pandaseq.fa', expand(outbase + ".pandaseq_{alg}.fa", alg=pandaseq_algorithms)



rule clean: 
  shell: "rm *pandaseq* *trimmed* *noheaders* *base_compositions* || true "




rule analytics: 
  output: "{base}.base_compositions.txt"
  input: "{base}.noheaders.txt"
  message: "running analysis script on {wildcards.base}.noheaders.txt"
  shell: "python analysis_script.py {input} {output}"

rule remove_fasta_headers: 
  output: "{base}.noheaders.txt"
  input: "{base}.pandaseq.fa" 
  message: "removing headers from {input}"
  shell: "cat {input} | grep -v '^>' > {output}"


rule pandalign_with_algorithm: 
  output: "{base}.pandaseq_{alg}.fa", "{base}.pandaseq_{alg}.log"
  input: "{base}.R1.trimmed.fastq", "{base}.R2.trimmed.fastq"
  message: "pandaseq aligning to {output}"
  shell: "pandaseq -N -L 53 -o 50 -f {input[0]} -r {input[1]}  -A {wildcards.alg} -w {output[0]} -g {output[1]}"


rule pandalign_default: 
  output: "{base}.pandaseq.fa", "{base}.pandaseq.log"
  input: "{base}.R1.trimmed.fastq", "{base}.R2.trimmed.fastq"
  message: "aligning overlaps with pandaseq, moving to {output[0]}"
  shell: "pandaseq -N -L 53 -o 50 -f {input[0]} -r {input[1]} -w {output[0]} -g {output[1]}"


rule trim_R1: 
  output: "{base}.R1.trimmed.fastq"
  input: "{base}.R1.fastq"
  message: "trimming {input} read 1"
  shell: "fastx_trimmer -l 52 -i {input} -o {output} -Q 33"

rule trim_R2: 
  output: "{base}.R2.trimmed.fastq"
  input: "{base}.R2.fastq"
  message: "trimming {input} read 2"
  shell: "fastx_trimmer -f 6 -l 58 -i {input} -o {output} -Q 33"

