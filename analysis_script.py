#!/usr/bin/python 

from difflib import SequenceMatcher
import sys, os 
import operator

def similar(a, b):
	return SequenceMatcher(None, a, b).ratio()

root_seq = 'NNNNNCCCGGGNNNAAGGCCGAATTCTCACCGGCCCCAAGGTATTCAAGNNNC'

similarity_threshold = 0.70 
critical_threshold = 0.10


similarities = []
seqs_to_analyze = []
outfile = sys.argv[2]
for seq in open(sys.argv[1]).readlines():
	seq.rstrip()
	s = similar(root_seq[6:99], seq[6:99])
	similarities.append(s)
	if s > similarity_threshold: 
		seqs_to_analyze.append(seq)





char_dic = {}
for i in range(0,len(seqs_to_analyze[0])-1): 
	char_dic[i] = []

for seq in seqs_to_analyze:
	if len(seq) == len(seqs_to_analyze[0]): 
		for i in range(0,len(seq)-1):
			char_dic[i].append(seq[i])

# print char_dic 

count_dic = {}
for i in range(0,len(seqs_to_analyze[0])-1): 
	count_dic[i] = {} 
	for c in ['G', 'A', 'T', 'C']: 
		count_dic[i][c] = char_dic[i].count(c)
# print count_dic 

percent_dic = {}
for i in count_dic.keys(): 
	cs = count_dic[i]
	s = sum(cs.values())
	percent_dic[i] = {}
	for c in cs: 
		percent_dic[i][c] = float(cs[c]) / float(s)
# print percent_dic

out = open(outfile, 'w')
print_dic = {} 
for i in percent_dic.keys(): 
	percs = percent_dic[i] 
	dom_char = max(percs.iteritems(), key=operator.itemgetter(1))[0]
	critical_chars = [] 
	for k in percs: 
		if percs[k] > critical_threshold:
			critical_chars.append(k)  
	i+=1
	ln = "{}    G: {}  A: {}  T: {}  C: {}    {}    {}".format("%.2d" % i, "%.2f" % percs['G'], "%.2f" % percs['A'], "%.2f" % percs['T'], "%.2f" % percs['C'], dom_char, '/'.join(critical_chars))
	# print ln 
	out.write(ln + '\n')
out.close()





