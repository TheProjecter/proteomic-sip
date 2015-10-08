<pre>
Instructions:<br>
<br>
0. Convert RAW files to FT2 files using Raxport https://code.google.com/p/raxport<br>
<br>
<br>
1.  Write the config files for either carbon or nitrogen to a directory.<br>
<br>
Example:<br>
write_config_files.pl default_sip_config.xml myfastadb.fna /home/me/config_files/ C<br>
<br>
# Usage: write_config_files.pl <config file> <database path> <config directory> < C | N ><br>
# config file = the config file to read in<br>
# database path = the FASTA database you want to search, needed to write into the config file<br>
# config directory = the directory you want to store the config files in<br>
# C | N = carbon or nitrogen enrichment<br>
<br>
2.  Run the enrichment job on a cluster with a PBS queue system.<br>
<br>
Example:<br>
run_enrichment_job.pl /home/me/sipros.exe /home/me/config_files /home/me/myrun/<br>
<br>
# usage: run_enrichment_job.pl <sipros> <config directory> <working directory><br>
<br>
# polyscan = the full path to the polyscan binary<br>
# config directory = the directory in which you placed the config files<br>
# working directory = a working directory in which you have placed your FT2 files<br>
#                     for analysis<br>
<br>
3.  Parse the raw output on the cluster.<br>
<br>
Example:<br>
parse_raw_output.pl -w /home/me/myrun -t 25.0 > myrawoutput.txt<br>
<br>
# usage: parse_raw_output.pl -w <working_directory> -t <score thresholdold><br>
# working_directory = directory containing the 101 output files<br>
# score thresholdold = minimum score to retain an entry, 25.0 is the default<br>
<br>
4.  Copy the file to your local machine (or continue work on the cluster, up to you).<br>
<br>
5.  Cluster by enrichment % and print out the three table files.<br>
<br>
Example:<br>
build_protein_tables.pl /home/me/zpb/finalout 10.0 < myrawoutput.txt<br>
<br>
# usage: build_protein_tables.pl <output prefix> <threshold>   <   <input_file><br>
# output prefix = will write the three filenames beginning with this prefix<br>
# threshold = clustering threshold, i.e. clusters greater than this<br>
#             distance will not be merged<br>
# This script reads from standard input.<br>
<br>
6.  Filter the peptides, removing proteins that are subsets of other proteins<br>
and proteins with fewer than some threshold # of peptides identified.<br>
<br>
Example:<br>
filter_peptides.pl /home/me/zpb/finalout 2 2 1 1<br>
<br>
# usage:  filter_peptides.pl <prefix> <min # peptides> <min # scans> <do_subset> <do_grouping><br>
#<br>
# prefix = The prefix for the three output files.<br>
# min # peptides = Minimum number of peptides to retain an entry.<br>
# min # scans = Minimum number of scans to retain an entry<br>
# do_subset = 0 or 1, Should we delete proteins whose ids are subset of another?<br>
# do_grouping = 0 or 1, Should we merge proteins whose ids are identical?<br>
<br>
7.  Run ProRata for quantification information.<br>
<br>
Example:<br>
run_prorata.pl ProRataConfig_Template.xml DTASelect-filter_Template.txt /home/me/quant<br>
<br>
# usage: run_prorata.pl <prorataconfig> <dtafiltertemplate> <working_dir><br>
# prorataconfig = ProRata config file<br>
# dtafiltertemplate = DTA Select template to read and copy<br>
# working_dir = The directory containing the three SIPROS protein table files.<br>
<br>
</pre>