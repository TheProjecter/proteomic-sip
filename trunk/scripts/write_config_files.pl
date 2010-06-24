#!/usr/bin/perl

# write_config_files.pl

# This script takes the default config file and writes 101 config files to a specified
# directory, one for each % enrichment level of carbon or nitrogen.

# Usage: write_config_files.pl <config file> <database path> <config directory> < C | N | H > ( <lower bound> <upper bound> <step size> )";
# config file = the config file to read in
# database path = the FASTA database you want to search, needed to write into the config file
# config directory = the directory you want to store the config files in
# C | N | H = carbon or nitrogen or hydrogen enrichment
# lower_bound = lowest % to run on (default 0.0)
# upper bound = upper bound % (default 1.006)
# step size = step size to increment through between each config file (default 0.01)

$config = shift;
$database = shift;
$working_dir = shift;
$enrich_target = shift;
$lower_bound = shift;
$upper_bound = shift;
$step_size = shift;

$usage = "usage: $0 <config file> <database path> <config directory> < C | N | H > ( <lower bound> <upper bound> <step size> )";

if($config eq "" || $database eq "" || $working_dir eq "" || $enrich_target eq "") { die $usage; }
if($lower_bound ne "" && ($upper_bound eq "" || $step_size eq "" || $upper_bound < $lower_bound)) { die $usage; }

if($lower_bound eq "") { $lower_bound = 0.0; $upper_bound = 1.0; $step_size = 0.01; }

# 30, 34, and 42 are the line numbers in the config file to modify for carbon, hydrogen, and nitrogen %'s
if($enrich_target =~ /^[Cc]/) { $enrich_target = 30; }
elsif($enrich_target =~ /^[Nn]/) { $enrich_target = 42; }
elsif($enrich_target =~ /^[Hh]/) { $enrich_target = 34; }
else { die "enrich_target must be one of C or N\n"; }

$counter = 1;

open FH, $config or die "couldn't open config file\n";
@content = <FH>;
close FH;

# Loop through in 0.01 (or specified step_size) increments and set the enrichment levels in each config file
for($i = $lower_bound; $i <= $upper_bound+0.006; $i+= $step_size) 
{
	open FH, ">$working_dir/config.$counter" or die "couldn't open config.$counter for writing (check working dir: $working_dir)\n";
	for($j = 0; $j < @content; $j++) 
	{
		if($j == 3) 
		{ 
			print FH "        <FASTA_DATABASE>$database<\/FASTA_DATABASE>\n"; 
		}
		elsif($j == $enrich_target && $counter != 2) 
		{ 
			if($content[$j] !~ /PERCENT/) 
			{ 
				die "bad line in config $content[$j]\n"; 
			}
			printf FH "\t\t<PERCENTAGE>\t%.4f,\t%.4f\t</PERCENTAGE>\n", 1.0-$i, $i;
		}
		else 
		{ 
			print FH $content[$j]; 
		}
	}
	close FH;
	$counter++;
}
