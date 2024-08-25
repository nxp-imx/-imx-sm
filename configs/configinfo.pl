#!/usr/bin/perl
## ###################################################################
##
## Copyright 2024 NXP
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##
## o Redistributions of source code must retain the above copyright notice, this list
##   of conditions and the following disclaimer.
##
## o Redistributions in binary form must reproduce the above copyright notice, this
##   list of conditions and the following disclaimer in the documentation and/or
##   other materials provided with the distribution.
##
## o Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from this
##   software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
## ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
## WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
## DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
## ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
## (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
## LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
## ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
## (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
## SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##
##
## ###################################################################

use strict;
use warnings;
use bigint;
use Getopt::Std;
use File::Basename;
use lib dirname (__FILE__);
use Data::Dumper;
use List::Util qw(first);

# Subroutines
sub load_config_files;
sub load_file;
sub generate_rsrc;
sub param;
sub get_define;

my %args;

# Parse command line
getopts('hi:', \%args);
my $help = $args{h};
my $inputFile = $args{i};

# Check for required arguments
if ($help || (not defined $inputFile))
{
    my $cmd = fileparse($0);

    print "Usage: $cmd [OPTIONS]...\n";
    print "Dump info from SM configuration files.\n\n";
    print "  -i  specify input file\n";
    print "  -h  display this help and exit\n\n";
    print "The input configuration file is loaded, processed, and\n";
    print "information written to STDOUT\n";
    exit;
}

# Support other cfg files
if (defined $inputFile)
{
	my $otherInputFile = $inputFile;
    $otherInputFile =~ s/configs/configs\/other/g;

	if (-e $otherInputFile)
	{
		$inputFile = $otherInputFile;
	}
}

# Load config files
my @cfg = &load_config_files($inputFile); 

# Generate DOX file
&generate_rsrc(\@cfg);

###############################################################################

sub load_config_files
{
    my ($cfgFile) = @_;

    # Load input file
    my @cfg = &load_file($cfgFile);

    # Remove duplicate words
    foreach (@cfg)
    {
        my (%before, @words, @new);

        @words = split(/ /, $_);
        @new = grep { ! $before{$_}++ } @words;
        $_ = join ' ', @new;
    }

    # Cleanup
    @cfg = grep(!/^DATA:/, @cfg);
    @cfg = grep(!/^EXEC:/, @cfg);
    @cfg = grep(!/^READONLY:/, @cfg);
    @cfg = grep(!/^OWNER:/, @cfg);
    @cfg = grep(!/^CONTROL:/, @cfg);
    @cfg = grep(!/^DFMT0:/, @cfg);
    @cfg = grep(!/^DFMT1:/, @cfg);
    @cfg = grep(!/^TEST_MU:/, @cfg);
    @cfg = grep(!/^ACCESS:/, @cfg);
    @cfg = grep(!/^ALL_RO:/, @cfg);
    @cfg = grep(!/^PD_/, @cfg);

    # Remove leading/trailing spaces
    s/^\s+|\s+$//g for @cfg;

    # Remove extra spaces
    s/\s+/ /g for @cfg;

    # Append end marker
    push @cfg, 'EOF';

    # Append space at end of every line
    s/$/ /g for @cfg;

    return @cfg; 
}

###############################################################################

sub load_file
{
    my ($fileName) = @_;
    my @contents;
    my $line = '';
    my $lineNum = 1;

    # Open file
    open my $in, '<', $fileName
        or die "error: failure to open: $fileName, $!";

    # Load into array
    while (<$in>)
    {
        # Remove LF
        chomp $_;

        # Continue line?
        if (/\\$/)
        {
            $_ =~ s/\\$//;
            $line .= $_ . ' ';
        }
        elsif (/^include/)
        {
            # Get fileName
            my($first, $rest) = split(/ /, $_, 2);

            # Load include file
            my @inc = &load_file(dirname($fileName) . '/' . $rest);

            # Append to contents
            push @contents, @inc;
        }
        else
        {
            $line .= $_;

            push @contents, $line;
            $line = '';
        }
        $lineNum++;
    }

    # Replace ,
    s/,/ /g for @contents;

    # Remove tabs
    s/\t/ /g for @contents;

    # Remove leading/trailing spaces
    s/^\s+|\s+$//g for @contents;

    # Remove extra spaces
    s/\s+/ /g for @contents;

    # Remove empty lines
    @contents = grep(/\S/, @contents);
    @contents = grep(!/^filename=/, @contents);

    # Remove comment lines
    @contents = grep(!/^#/, @contents);

    # Close file
    close($in);

    return @contents;
}

###############################################################################

sub generate_rsrc
{
    my ($cfgRef) = @_;
    my @rsrc = grep(/^[A-Z0-9_]+: /, @$cfgRef);
    my @list = grep(!/^[A-Z0-9_]+: /, @$cfgRef);

	# Filter
	@rsrc = sort @rsrc;
    @rsrc = grep(!/nrgns/, @rsrc);
    @rsrc = grep(!/nblks/, @rsrc);

	# Print header
	print '| Resource | DOM |';

    # Loop over LM
	my @lm = grep(/^LM[0-9]+ /, @list);
    foreach my $l (@lm)
	{
        if ($l =~ /^(LM[0-9]+) /)
        {
        	print ' ' . $1 . ' |';
        }
	}
	print "\n";

    # Loop over resources
    foreach my $r (@rsrc)
    {
        if ($r =~ /^([A-Z0-9_]+): /)
        {
			my $name = $1;
			print '| ' . $name . ' |';

			my $cnt = 0;
			my $dom = '';
			my @lmRsrc = grep(/^LM[0-9]+ /  || /^DOM[0-9]+ / || /^$name /,
				@list);
		    foreach my $l (@lmRsrc)
			{
		        if ($l =~ /^LM[0-9]+ /)
		        {
		        	print ' |';
		        	$cnt++;
		        }
		        elsif ($l =~ /^DOM([0-9]+) /)
		        {
		        	$dom = $1;
		        }
		        elsif ($cnt > 0)
		        {
        			my @words = split(/ /, $l);

		        	print ' ' . $words[1];
		        }
		        else
		        {
		        	print ' ' . $dom;
		        }
			}
			print ' |' . "\n";

#			print Dumper(@lmRsrc);
        }
   	}

#	print Dumper(@rsrc);
}

###############################################################################

sub param
{
    my ($line, $name) = @_;

    # Find pair name=value
    if ($line =~ /\b$name=[\w\-\.\/"\|]+\s/)
    {
        $line =~ /\b$name=([\w\-\.\/"\|]+)\s/;

        return $1;
    }

    # Return not found indicator
    return '!';
}

###############################################################################

sub get_define
{
	my ($str, $aRef) = @_;

    my @define = grep(/^$str /, @$aRef);

	if (@define)
	{
        my @words = split(/ /, $define[0]);

		if ($words[1])
		{
			return $words[1];
		}
	}
}
