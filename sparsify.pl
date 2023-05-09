#!/usr/bin/perl

use strict;
use warnings;

my $re_line = qr/^(?<type>\S+)\s+(?<data>.+)$/o;
my $re_keep = qr/^telenode|eggpod|overmind|reactor|arm|medistat|booster$/o;

my $path = shift or die "Syntax: $0 <path-to-file> <percent>";
my $percent = shift or die "Syntax: $0 <path-to-file> <percent>";

die "Percent of buildings to remove is not a number" if ($percent !~ /^\d+$/);
die "Percent of buildings to remove must be between 1 and 99" if ($percent < 1 or $percent > 100);

my %buildings;
open FI,'<',$path;
while(my $line = <FI>) {
    if ($line =~ $re_line) {
	$buildings{$+{type}} //= [];
	push @{$buildings{$+{type}}}, {
	    type => $+{type},
	    data => $+{data}
	};
    }
}
close FI;

while (my ($type, $entries) = each(%buildings)) {
    if ($type !~ $re_keep) {
	@$entries = grep { int(rand(100)) < $percent } @$entries;
    }
    print map { "$_->{type} $_->{data}\n" } @$entries;
}
