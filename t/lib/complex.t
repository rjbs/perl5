#!./perl

# $RCSfile$
#
# Regression tests for the new Math::Complex pacakge
# -- Raphael Manfredi, Septemeber 1996
# -- Jarkko Hietaniemi Manfredi, March 1997
# -- Dominic Dunlop, March 1997 (reduce virtual memory requirement only)
BEGIN {
    chdir 't' if -d 't';
    @INC = '../lib';
}
use Math::Complex;

$test = 0;
$| = 1;
@script = ();
my $eps = 1e-4; # for example root() is quite bad

while (<DATA>) {
	s/^\s+//;
	next if $_ eq '' || /^\#/;
	chomp;
	$test_set = 0;		# Assume not a test over a set of values
	if (/^&(.*)/) {
		$op = $1;
		next;
	}
	elsif (/^\{(.*)\}/) {
		set($1, \@set, \@val);
		next;
	}
	elsif (s/^\|//) {
		$test_set = 1;	# Requests we loop over the set...
	}
	my @args = split(/:/);
	if ($test_set == 1) {
		my $i;
		for ($i = 0; $i < @set; $i++) {
			# complex number
			$target = $set[$i];
			# textual value as found in set definition
			$zvalue = $val[$i];
			test($zvalue, $target, @args);
		}
	} else {
		test($op, undef, @args);
	}
}

print "1..$test\n";
eval join '', @script;
die $@ if $@;

sub test {
	my ($op, $z, @args) = @_;
	$test++;
	my $i;
	for ($i = 0; $i < @args; $i++) {
		$val = value($args[$i]);
                push @script, "\$z$i = $val;\n";
	}
	if (defined $z) {
		$args = "'$op'";		# Really the value
		$try = "abs(\$z0 - \$z1) <= $eps ? \$z1 : \$z0";
                push @script, "\$res = $try; ";
                push @script, "check($test, $args[0], \$res, \$z$#args, $args);\n";
	} else {
		my ($try, $args);
		if (@args == 2) {
			$try = "$op \$z0";
			$args = "'$args[0]'";
		} else {
			$try = ($op =~ /^\w/) ? "$op(\$z0, \$z1)" : "\$z0 $op \$z1";
			$args = "'$args[0]', '$args[1]'";
		}
                push @script, "\$res = $try; ";
                push @script, "check($test, '$try', \$res, \$z$#args, $args);\n";
	}
}

sub set {
	my ($set, $setref, $valref) = @_;
	@{$setref} = ();
	@{$valref} = ();
	my @set = split(/;\s*/, $set);
	my @res;
	my $i;
	for ($i = 0; $i < @set; $i++) {
		push(@{$valref}, $set[$i]);
		my $val = value($set[$i]);
                push @script, "\$s$i = $val;\n";
		push(@{$setref}, "\$s$i");
	}
}

sub value {
	local ($_) = @_;
	if (/^\s*\((.*),(.*)\)/) {
		return "cplx($1,$2)";
	}
	elsif (/^\s*\[(.*),(.*)\]/) {
		return "cplxe($1,$2)";
	}
	elsif (/^\s*'(.*)'/) {
		my $ex = $1;
		$ex =~ s/\bz\b/$target/g;
		$ex =~ s/\br\b/abs($target)/g;
		$ex =~ s/\bt\b/arg($target)/g;
		$ex =~ s/\ba\b/Re($target)/g;
		$ex =~ s/\bb\b/Im($target)/g;
		return $ex;
	}
	elsif (/^\s*"(.*)"/) {
		return "\"$1\"";
	}
	return $_;
}

sub check {
	my ($test, $try, $got, $expected, @z) = @_;

#	print "# @_\n";

	if ("$got" eq "$expected"
	    ||
	    ($expected =~ /^-?\d/ && $got == $expected)
	    ||
	    (abs($got - $expected) < $eps)
	    ) {
		print "ok $test\n";
	} else {
		print "not ok $test\n";
		my $args = (@z == 1) ? "z = $z[0]" : "z0 = $z[0], z1 = $z[1]";
		print "# '$try' expected: '$expected' got: '$got' for $args\n";
	}
}
__END__
&+
(3,4):(3,4):(6,8)
(-3,4):(3,-4):(0,0)
(3,4):-3:(0,4)
1:(4,2):(5,2)
[2,0]:[2,pi]:(0,0)

&++
(2,1):(3,1)

&-
(2,3):(-2,-3)
[2,pi/2]:[2,-(pi)/2]
2:[2,0]:(0,0)
[3,0]:2:(1,0)
3:(4,5):(-1,-5)
(4,5):3:(1,5)

&--
(1,2):(0,2)
[2,pi]:[3,pi]

&*
(0,1):(0,1):(-1,0)
(4,5):(1,0):(4,5)
[2,2*pi/3]:(1,0):[2,2*pi/3]
2:(0,1):(0,2)
(0,1):3:(0,3)
(0,1):(4,1):(-1,4)
(2,1):(4,-1):(9,2)

&/
(3,4):(3,4):(1,0)
(4,-5):1:(4,-5)
1:(0,1):(0,-1)
(0,6):(0,2):(3,0)
(9,2):(4,-1):(2,1)
[4,pi]:[2,pi/2]:[2,pi/2]
[2,pi/2]:[4,pi]:[0.5,-(pi)/2]

&Re
(3,4):3
(-3,4):-3
[1,pi/2]:0

&Im
(3,4):4
(3,-4):-4
[1,pi/2]:1

&abs
(3,4):5
(-3,4):5

&arg
[2,0]:0
[-2,0]:pi

&~
(4,5):(4,-5)
(-3,4):(-3,-4)
[2,pi/2]:[2,-(pi)/2]

&<
(3,4):(1,2):0
(3,4):(3,2):0
(3,4):(3,8):1
(4,4):(5,129):1

&==
(3,4):(4,5):0
(3,4):(3,5):0
(3,4):(2,4):0
(3,4):(3,4):1

&sqrt
-9:(0,3)
(-100,0):(0,10)
(16,-30):(5,-3)

&stringify_cartesian
(-100,0):"-100"
(0,1):"i"
(4,-3):"4-3i"
(4,0):"4"
(-4,0):"-4"
(-2,4):"-2+4i"
(-2,-1):"-2-i"

&stringify_polar
[-1, 0]:"[1,pi]"
[1, pi/3]:"[1,pi/3]"
[6, -2*pi/3]:"[6,-2pi/3]"
[0.5, -9*pi/11]:"[0.5,-9pi/11]"

{ (4,3); [3,2]; (-3,4); (0,2); [2,1] }

|'z + ~z':'2*Re(z)'
|'z - ~z':'2*i*Im(z)'
|'z * ~z':'abs(z) * abs(z)'

{ (2,3); [3,2]; (-3,2); (0,2); 3; 1.2; -3; (-3, 0); (-2, -1); [2,1] }

|'(root(z, 4))[1] ** 4':'z'
|'(root(z, 5))[3] ** 5':'z'
|'(root(z, 8))[7] ** 8':'z'
|'abs(z)':'r'
|'acot(z)':'acotan(z)'
|'acsc(z)':'acosec(z)'
|'acsc(z)':'asin(1 / z)'
|'asec(z)':'acos(1 / z)'
|'cbrt(z)':'cbrt(r) * exp(i * t/3)'
|'cos(acos(z))':'z'
|'cos(z) ** 2 + sin(z) ** 2':1
|'cos(z)':'cosh(i*z)'
|'cosh(z) ** 2 - sinh(z) ** 2':1
|'cot(acot(z))':'z'
|'cot(z)':'1 / tan(z)'
|'cot(z)':'cotan(z)'
|'csc(acsc(z))':'z'
|'csc(z)':'1 / sin(z)'
|'csc(z)':'cosec(z)'
|'exp(log(z))':'z'
|'exp(z)':'exp(a) * exp(i * b)'
|'ln(z)':'log(z)'
|'log(exp(z))':'z'
|'log(z)':'log(r) + i*t'
|'log10(z)':'log(z) / log(10)'
|'logn(z, 2)':'log(z) / log(2)'
|'logn(z, 3)':'log(z) / log(3)'
|'sec(asec(z))':'z'
|'sec(z)':'1 / cos(z)'
|'sin(asin(z))':'z'
|'sin(i * z)':'i * sinh(z)'
|'sqrt(z) * sqrt(z)':'z'
|'sqrt(z)':'sqrt(r) * exp(i * t/2)'
|'tan(atan(z))':'z'
|'z**z':'exp(z * log(z))'

{ (1,1); [1,0.5]; (-2, -1); 2; -3; (-1,0.5); (0,0.5); 0.5; (2, 0); (-1, -2) }

|'cosh(acosh(z))':'z'
|'coth(acoth(z))':'z'
|'coth(z)':'1 / tanh(z)'
|'coth(z)':'cotanh(z)'
|'csch(acsch(z))':'z'
|'csch(z)':'1 / sinh(z)'
|'csch(z)':'cosech(z)'
|'sech(asech(z))':'z'
|'sech(z)':'1 / cosh(z)'
|'sinh(asinh(z))':'z'
|'tanh(atanh(z))':'z'

{ (0.2,-0.4); [1,0.5]; -1.2; (-1,0.5); 0.5; (1.1, 0) }

|'acos(cos(z)) ** 2':'z * z'
|'acosh(cosh(z)) ** 2':'z * z'
|'acoth(z)':'acotanh(z)'
|'acoth(z)':'atanh(1 / z)'
|'acsch(z)':'acosech(z)'
|'acsch(z)':'asinh(1 / z)'
|'asech(z)':'acosh(1 / z)'
|'asin(sin(z))':'z'
|'asinh(sinh(z))':'z'
|'atan(tan(z))':'z'
|'atanh(tanh(z))':'z'

&sin
( 2, 3):(  9.15449914691143, -4.16890695996656)
(-2, 3):( -9.15449914691143, -4.16890695996656)
(-2,-3):( -9.15449914691143,  4.16890695996656)
( 2,-3):(  9.15449914691143,  4.16890695996656)

&cos
( 2, 3):( -4.18962569096881, -9.10922789375534)
(-2, 3):( -4.18962569096881,  9.10922789375534)
(-2,-3):( -4.18962569096881, -9.10922789375534)
( 2,-3):( -4.18962569096881,  9.10922789375534)

&tan
( 2, 3):( -0.00376402564150,  1.00323862735361)
(-2, 3):(  0.00376402564150,  1.00323862735361)
(-2,-3):(  0.00376402564150, -1.00323862735361)
( 2,-3):( -0.00376402564150, -1.00323862735361)

&sec
( 2, 3):( -0.04167496441114,  0.09061113719624)
(-2, 3):( -0.04167496441114, -0.09061113719624)
(-2,-3):( -0.04167496441114,  0.09061113719624)
( 2,-3):( -0.04167496441114, -0.09061113719624)

&csc
( 2, 3):(  0.09047320975321,  0.04120098628857)
(-2, 3):( -0.09047320975321,  0.04120098628857)
(-2,-3):( -0.09047320975321, -0.04120098628857)
( 2,-3):(  0.09047320975321, -0.04120098628857)

&cot
( 2, 3):( -0.00373971037634, -0.99675779656936)
(-2, 3):(  0.00373971037634, -0.99675779656936)
(-2,-3):(  0.00373971037634,  0.99675779656936)
( 2,-3):( -0.00373971037634,  0.99675779656936)

&asin
( 2, 3):(  0.57065278432110,  1.98338702991654)
(-2, 3):( -0.57065278432110,  1.98338702991654)
(-2,-3):( -0.57065278432110, -1.98338702991654)
( 2,-3):(  0.57065278432110, -1.98338702991654)

&acos
( 2, 3):(  1.00014354247380, -1.98338702991654)
(-2, 3):(  2.14144911111600, -1.98338702991654)
(-2,-3):(  2.14144911111600,  1.98338702991654)
( 2,-3):(  1.00014354247380,  1.98338702991654)

&atan
( 2, 3):(  1.40992104959658,  0.22907268296854)
(-2, 3):( -1.40992104959658,  0.22907268296854)
(-2,-3):( -1.40992104959658, -0.22907268296854)
( 2,-3):(  1.40992104959658, -0.22907268296854)

&asec
( 2, 3):(  1.42041072246703,  0.23133469857397)
(-2, 3):(  1.72118193112276,  0.23133469857397)
(-2,-3):(  1.72118193112276, -0.23133469857397)
( 2,-3):(  1.42041072246703, -0.23133469857397)

&acsc
( 2, 3):(  0.15038560432786, -0.23133469857397)
(-2, 3):( -0.15038560432786, -0.23133469857397)
(-2,-3):( -0.15038560432786,  0.23133469857397)
( 2,-3):(  0.15038560432786,  0.23133469857397)

&acot
( 2, 3):(  0.16087527719832, -0.22907268296854)
(-2, 3):( -0.16087527719832, -0.22907268296854)
(-2,-3):( -0.16087527719832,  0.22907268296854)
( 2,-3):(  0.16087527719832,  0.22907268296854)

&sinh
( 2, 3):( -3.59056458998578,  0.53092108624852)
(-2, 3):(  3.59056458998578,  0.53092108624852)
(-2,-3):(  3.59056458998578, -0.53092108624852)
( 2,-3):( -3.59056458998578, -0.53092108624852)

&cosh
( 2, 3):( -3.72454550491532,  0.51182256998738)
(-2, 3):( -3.72454550491532, -0.51182256998738)
(-2,-3):( -3.72454550491532,  0.51182256998738)
( 2,-3):( -3.72454550491532, -0.51182256998738)

&tanh
( 2, 3):(  0.96538587902213, -0.00988437503832)
(-2, 3):( -0.96538587902213, -0.00988437503832)
(-2,-3):( -0.96538587902213,  0.00988437503832)
( 2,-3):(  0.96538587902213,  0.00988437503832)

&sech
( 2, 3):( -0.26351297515839, -0.03621163655877)
(-2, 3):( -0.26351297515839,  0.03621163655877)
(-2,-3):( -0.26351297515839, -0.03621163655877)
( 2,-3):( -0.26351297515839,  0.03621163655877)

&csch
( 2, 3):( -0.27254866146294, -0.04030057885689)
(-2, 3):(  0.27254866146294, -0.04030057885689)
(-2,-3):(  0.27254866146294,  0.04030057885689)
( 2,-3):( -0.27254866146294,  0.04030057885689)

&coth
( 2, 3):(  1.03574663776500,  0.01060478347034)
(-2, 3):( -1.03574663776500,  0.01060478347034)
(-2,-3):( -1.03574663776500, -0.01060478347034)
( 2,-3):(  1.03574663776500, -0.01060478347034)

&asinh
( 2, 3):(  1.96863792579310,  0.96465850440760)
(-2, 3):( -1.96863792579310,  0.96465850440761)
(-2,-3):( -1.96863792579310, -0.96465850440761)
( 2,-3):(  1.96863792579310, -0.96465850440760)

&acosh
( 2, 3):(  1.98338702991654,  1.00014354247380)
(-2, 3):( -1.98338702991653, -2.14144911111600)
(-2,-3):( -1.98338702991653,  2.14144911111600)
( 2,-3):(  1.98338702991654, -1.00014354247380)

&atanh
( 2, 3):(  0.14694666622553,  1.33897252229449)
(-2, 3):( -0.14694666622553,  1.33897252229449)
(-2,-3):( -0.14694666622553, -1.33897252229449)
( 2,-3):(  0.14694666622553, -1.33897252229449)

&asech
( 2, 3):(  0.23133469857397, -1.42041072246703)
(-2, 3):( -0.23133469857397,  1.72118193112276)
(-2,-3):( -0.23133469857397, -1.72118193112276)
( 2,-3):(  0.23133469857397,  1.42041072246703)

&acsch
( 2, 3):(  0.15735549884499, -0.22996290237721)
(-2, 3):( -0.15735549884499, -0.22996290237721)
(-2,-3):( -0.15735549884499,  0.22996290237721)
( 2,-3):(  0.15735549884499,  0.22996290237721)

&acoth
( 2, 3):(  0.14694666622553, -0.23182380450040)
(-2, 3):( -0.14694666622553, -0.23182380450040)
(-2,-3):( -0.14694666622553,  0.23182380450040)
( 2,-3):(  0.14694666622553,  0.23182380450040)

# eof
