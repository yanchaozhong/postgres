#!/usr/bin/perl
#
# Generate the plerrcodes.h header from errcodes.txt
# Copyright (c) 2000-2012, PostgreSQL Global Development Group

use warnings;
use strict;

print
  "/* autogenerated from src/backend/utils/errcodes.txt, do not edit */\n";
print "/* there is deliberately not an #ifndef PLERRCODES_H here */\n";

open my $errcodes, $ARGV[0] or die;

while (<$errcodes>)
{
	chomp;

	# Skip comments
	next if /^#/;
	next if /^\s*$/;

	# Skip section headers
	next if /^Section:/;

	die unless /^([^\s]{5})\s+([EWS])\s+([^\s]+)(?:\s+)?([^\s]+)?/;

	(my $sqlstate, my $type, my $errcode_macro, my $condition_name) =
	  ($1, $2, $3, $4);

	# Skip non-errors
	next unless $type eq 'E';

	# Skip lines without PL/pgSQL condition names
	next unless defined($condition_name);

	print "{\n\t\"$condition_name\", $errcode_macro\n},\n\n";
}

close $errcodes;
