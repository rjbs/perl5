#!/usr/bin/perl -w

#
# Generate overload.h
# This allows the order of overloading constants to be changed.
# 

BEGIN {
    # Get function prototypes
    require 'regen_lib.pl';
}

use strict;

my (@enums, @names);
while (<DATA>) {
  next if /^#/;
  next if /^$/;
  my ($enum, $name) = /^(\S+)\s+(\S+)/ or die "Can't parse $_";
  # No smart match in 5.8.x
  next if $enum eq 'smart';
  push @enums, $enum;
  push @names, $name;
}

safer_unlink ('overload.h', 'overload.c');
die "overload.h: $!" unless open(C, ">overload.c");
binmode C;
die "overload.h: $!" unless open(H, ">overload.h");
binmode H;

sub print_header {
  my $file = shift;
  print <<"EOF";
/* -*- buffer-read-only: t -*-
 *
 *    $file
 *
 *    Copyright (C) 1997, 1998, 2000, 2001, 2005, 2006, 2007 by Larry Wall
 *    and others
 *
 *    You may distribute under the terms of either the GNU General Public
 *    License or the Artistic License, as specified in the README file.
 *
 *  !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
 *  This file is built by overload.pl
 */
EOF
}

select C;
print_header('overload.c');

select H;
print_header('overload.h');
print <<'EOF';

enum {
EOF

print "    ${_}_amg,\n", foreach @enums;

print <<'EOF';
    max_amg_code
    /* Do not leave a trailing comma here.  C9X allows it, C89 doesn't. */
};

#define NofAMmeth max_amg_code
#define AMG_id2name(id) (PL_AMG_names[id]+1)

#ifdef DOINIT
EXTCONST char * const PL_AMG_names[NofAMmeth] = {
  /* Names kept in the symbol table.  fallback => "()", the rest has
     "(" prepended.  The only other place in perl which knows about
     this convention is AMG_id2name (used for debugging output and
     'nomethod' only), the only other place which has it hardwired is
     overload.pm.  */
EOF

print C <<'EOF';

#define AMG_id2namelen(id) (PL_AMG_namelens[id]-1)

const U8 PL_AMG_namelens[NofAMmeth] = {
EOF

my $last = pop @names;

print C "    $_,\n" foreach map { length $_ } @names;

my $lastlen = length $last;
print C <<"EOT";
    $lastlen
};
EOT

print H "    \"$_\",\n" foreach map { s/(["\\"])/\\$1/g; $_ } @names;

print H <<"EOT";
    "$last"
};
#else
EXTCONST char * PL_AMG_names[NofAMmeth];
#endif /* def INITAMAGIC */
EOT

close H or die $!;
close C or die $!;

__DATA__
# This is the 5.8.8 order.
# fallback => "()", the rest have"(" prepended.
# Fallback should be the first
fallback	()
abs		(abs
bool_		(bool
nomethod	(nomethod
string		(""
numer		(0+
add		(+
add_ass		(+=
subtr		(-
subtr_ass	(-=
mult		(*
mult_ass	(*=
div		(/
div_ass		(/=
modulo		(%
modulo_ass	(%=
pow		(**
pow_ass		(**=
lshift		(<<
lshift_ass	(<<=
rshift		(>>
rshift_ass	(>>=
band		(&
band_ass	(&=
bor		(|
bor_ass		(|=
bxor		(^
bxor_ass	(^=
lt		(<
le		(<=
gt		(>
ge		(>=
eq		(==
ne		(!=
ncmp		(<=>
scmp		(cmp
slt		(lt
sle		(le
sgt		(gt
sge		(ge
seq		(eq
sne		(ne
not		(!
compl		(~
inc		(++
dec		(--
atan2		(atan2
cos		(cos
sin		(sin
exp		(exp
log		(log
sqrt		(sqrt
repeat		(x
repeat_ass	(x=
concat		(.
concat_ass	(.=
copy		(=
neg		(neg
to_sv		(${}
to_av		(@{}
to_hv		(%{}
to_gv		(*{}
to_cv		(&{}
iter		(<>
int		(int
# Note: Perl_Gv_AMupdate() assumes that DESTROY is the last entry
DESTROY		DESTROY
