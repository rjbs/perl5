BEGIN {
    # Get function prototypes
    require 'regen_lib.pl';
}
#use Fatal qw(open close rename chmod unlink);
use strict;
use warnings;

open DESC, 'regcomp.sym';

my $ind = 0;
my (@name,@rest,@type,@code,@args,@longj);
my ($desc,$lastregop);
while (<DESC>) {
    s/#.*$//;
    next if /^\s*$/;
    s/\s*\z//;
    if (/^-+\s*$/) {
        $lastregop= $ind;
        next;
    }
    unless ($lastregop) {
        $ind++;
        ($name[$ind], $desc, $rest[$ind]) = split /\t+/, $_, 3;  
        ($type[$ind], $code[$ind], $args[$ind], $longj[$ind]) 
          = split /[,\s]\s*/, $desc, 4;
    } else {
        my ($type,@lists)=split /\s*\t+\s*/, $_;
        die "No list? $type" if !@lists;
        foreach my $list (@lists) {
            my ($names,$special)=split /:/, $list , 2;
            $special ||= "";
            foreach my $name (split /,/,$names) {
                my $real= $name eq 'resume' 
                        ? "resume_$type" 
                        : "${type}_$name";
                my @suffix;
                if (!$special) {
                   @suffix=("");
                } elsif ($special=~/\d/) {
                    @suffix=(1..$special);
                } elsif ($special eq 'FAIL') {
                    @suffix=("","_fail");
                } else {
                    die "unknown :type ':$special'";
                }
                foreach my $suffix (@suffix) {
                    $ind++;
                    $name[$ind]="$real$suffix";
                    $type[$ind]=$type;
                    $rest[$ind]="state for $type";
                }
            }
        }
        
    }
}
# use fixed width to keep the diffs between regcomp.pl recompiles
# as small as possible.
my ($width,$rwidth,$twidth)=(22,12,9);
$lastregop ||= $ind;
my $tot = $ind;
close DESC;
die "Too many regexp/state opcodes! Maximum is 256, but there are $lastregop in file!"
    if $lastregop>256;

my $tmp_h = 'tmp_reg.h';

unlink $tmp_h if -f $tmp_h;

my $out = safer_open($tmp_h);

printf $out <<EOP,
/* -*- buffer-read-only: t -*-
   !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
   This file is built by regcomp.pl from regcomp.sym.
   Any changes made here will be lost!
*/

/* Regops and State definitions */

#define %*s\t%d
#define %*s\t%d

EOP
    -$width, REGNODE_MAX        => $lastregop - 1,
    -$width, REGMATCH_STATE_MAX => $tot - 1
;


for ($ind=1; $ind <= $lastregop ; $ind++) {
  my $oind = $ind - 1;
  printf $out "#define\t%*s\t%d\t/* %#04x %s */\n",
    -$width, $name[$ind], $ind-1, $ind-1, $rest[$ind];
}
print $out "\t/* ------------ States ------------- */\n";
for ( ; $ind <= $tot ; $ind++) {
  printf $out "#define\t%*s\t(REGNODE_MAX + %d)\t/* %s */\n",
    -$width, $name[$ind], $ind - $lastregop, $rest[$ind];
}

print $out <<EOP;

/* PL_regkind[] What type of regop or state is this. */

#ifndef DOINIT
EXTCONST U8 PL_regkind[];
#else
EXTCONST U8 PL_regkind[] = {
EOP

$ind = 0;
while (++$ind <= $tot) {
  printf $out "\t%*s\t/* %*s */\n",
             -1-$twidth, "$type[$ind],", -$width, $name[$ind];
  print $out "\t/* ------------ States ------------- */\n"
    if $ind == $lastregop and $lastregop != $tot;
}

print $out <<EOP;
};
#endif

/* regarglen[] - How large is the argument part of the node (in regnodes) */

#ifdef REG_COMP_C
static const U8 regarglen[] = {
EOP

$ind = 0;
while (++$ind <= $lastregop) {
  my $size = 0;
  $size = "EXTRA_SIZE(struct regnode_$args[$ind])" if $args[$ind];
  
  printf $out "\t%*s\t/* %*s */\n",
	-37, "$size,",-$rwidth,$name[$ind];
}

print $out <<EOP;
};

/* reg_off_by_arg[] - Which argument holds the offset to the next node */

static const char reg_off_by_arg[] = {
EOP

$ind = 0;
while (++$ind <= $lastregop) {
  my $size = $longj[$ind] || 0;

  printf $out "\t%d,\t/* %*s */\n",
	$size, -$rwidth, $name[$ind]
}

print $out <<EOP;
};

#endif /* REG_COMP_C */

/* reg_name[] - Opcode/state names in string form, for debugging */

#ifndef DOINIT
EXTCONST char * PL_reg_name[];
#else
EXTCONST char * const PL_reg_name[] = {
EOP

$ind = 0;
my $ofs = 1;
my $sym = "";
while (++$ind <= $tot) {
  my $size = $longj[$ind] || 0;

  printf $out "\t%*s\t/* $sym%#04x */\n",
	-3-$width,qq("$name[$ind]",), $ind - $ofs;
  if ($ind == $lastregop and $lastregop != $tot) {
    print $out "\t/* ------------ States ------------- */\n";
    $ofs = $lastregop;
    $sym = 'REGNODE_MAX +';
  }
    
}

print $out <<EOP;
};
#endif /* DOINIT */

/* PL_reg_extflags_name[] - Opcode/state names in string form, for debugging */

#ifndef DOINIT
EXTCONST char * PL_reg_extflags_name[];
#else
EXTCONST char * const PL_reg_extflags_name[] = {
EOP

open my $fh,"<","regexp.h" or die "Can't read regexp.h: $!";
my %rxfv;
my $val = 0;
my %reverse;
while (<$fh>) {
    if (/#define\s+(RXf_\w+)\s+(0x[A-F\d]+)/i) {
	my $newval = eval $2;
	if($val & $newval) {
	    die sprintf "Both $1 and $reverse{$newval} use %08X", $newval;
	}
        $val|=$newval;
        $rxfv{$1}= $newval;
	$reverse{$newval} = $1;
    }
}    
my %vrxf=reverse %rxfv;
printf $out "\t/* Bits in extflags defined: %032b */\n",$val;
for (0..31) {
    my $n=$vrxf{2**$_}||"UNUSED_BIT_$_";
    $n=~s/^RXf_(PMf_)?//;
    printf $out qq(\t%-20s/* 0x%08x */\n), 
        qq("$n",),2**$_;
}  
 
print $out <<EOP;
};
#endif /* DOINIT */

/* ex: set ro: */
EOP
close $out or die "close $tmp_h: $!";

rename_if_different $tmp_h, 'regnodes.h';
