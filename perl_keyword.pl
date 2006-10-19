
# How to generate the logic of the lookup table Perl_keyword() in toke.c

use Devel::Tokenizer::C 0.05;
use strict;
use warnings;

my @pos = qw(__DATA__ __END__ AUTOLOAD BEGIN CHECK DESTROY default defined
	    delete do END else eval elsif exists for format foreach given grep
	    goto glob INIT if last local m my map next no our pos print printf
	    package prototype q qr qq qw qx redo return require s scalar sort
	    split state study sub tr tie tied use undef UNITCHECK until untie
	    unless when while y);

my @neg = qw(__FILE__ __LINE__ __PACKAGE__ and abs alarm atan2 accept bless
	    break bind binmode CORE cmp chr cos chop close chdir chomp chmod
	    chown crypt chroot caller connect closedir continue die dump
	    dbmopen dbmclose eq eof err exp exit exec each endgrent endpwent
	    endnetent endhostent endservent endprotoent fork fcntl flock fileno
	    formline getppid getpgrp getpwent getpwnam getpwuid getpeername
	    getprotoent getpriority getprotobyname getprotobynumber
	    gethostbyname gethostbyaddr gethostent getnetbyname getnetbyaddr
	    getnetent getservbyname getservbyport getservent getsockname
	    getsockopt getgrent getgrnam getgrgid getlogin getc gt ge gmtime
	    hex int index ioctl join keys kill lt le lc log link lock lstat
	    length listen lcfirst localtime mkdir msgctl msgget msgrcv msgsnd
	    ne not or ord oct open opendir pop push pack pipe quotemeta ref
	    read rand recv rmdir reset rename rindex reverse readdir readlink
	    readline readpipe rewinddir say seek send semop select semctl semget
	    setpgrp seekdir setpwent setgrent setnetent setsockopt sethostent
	    setservent setpriority setprotoent shift shmctl shmget shmread
	    shmwrite shutdown sin sleep socket socketpair sprintf splice sqrt
	    srand stat substr system symlink syscall sysopen sysread sysseek
	    syswrite tell time times telldir truncate uc utime umask unpack
	    unlink unshift ucfirst values vec warn wait write waitpid wantarray
	    x xor);

my %feature_kw = (
	given   => 'switch',
	when    => 'switch',
	default => 'switch',
	# continue is already a keyword
	break   => 'switch',

	say     => 'say',

	err	=> 'err',

	state	=> 'state',
	);

my %pos = map { ($_ => 1) } @pos;

my $t = Devel::Tokenizer::C->new( TokenFunc     => \&perl_keyword
                                , TokenString   => 'name'
                                , StringLength  => 'len'
                                , MergeSwitches => 1
                                );

$t->add_tokens(@pos, @neg, 'elseif');

my $switch = $t->generate(Indent => '  ');

print <<END;
/*
 *  The following code was generated by $0.
 */

I32
Perl_keyword (pTHX_ const char *name, I32 len, bool all_keywords)
{
    dVAR;
$switch
unknown:
  return 0;
}
END

sub perl_keyword
{
  my $k = shift;
  my $sign = $pos{$k} ? '' : '-';

  if ($k eq 'elseif') {
    return <<END;
if(ckWARN_d(WARN_SYNTAX))
  Perl_warner(aTHX_ packWARN(WARN_SYNTAX), "elseif should be elsif");
END
  }
  elsif (my $feature = $feature_kw{$k}) {
    $feature =~ s/([\\"])/\\$1/g;
    return <<END;
return (all_keywords || FEATURE_IS_ENABLED("$feature") ? ${sign}KEY_$k : 0);
END
  }
  return <<END;
return ${sign}KEY_$k;
END
}
