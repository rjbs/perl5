echo "# `Date -t` ----- Begin MacPerl tests."
echo ""
perl -le 'symlink "::macos:perl", ":perl" unless -e ":perl"'
# :perl -I::lib -e 'for(<:*:*.t>){open my $fh,"<$_";$t=<$fh>=~/(t)/i?"-$1":"  ";$s="$^X -I::lib $t $_ "; $t = ">> ::macos:MacPerlTests.out";print qq[echo "$s" $t\n$s $t\n]}'
set -e MACPERL ""
set -e PERL5LIB ""
perl -e '`set -e MACPERL_OLD "{{MACPERL}}"` if `echo {{MACPERL}}`'
perl -e '`set -e PERL5LIB_OLD "{{PERL5LIB}}"` if `echo {{PERL5LIB}}`'
perl -e '`set -e MACPERL ""`'
perl -e '`set -e PERL5LIB ""`'
echo "# When finished, execute these lines to restore your ToolServer environment:"
echo "perl -e '�`set -e MACPERL  �"�{�{MACPERL_OLD�}�}�"�`  if �`echo �{�{MACPERL_OLD�}�}�`'"
echo "perl -e '�`set -e PERL5LIB �"�{�{PERL5LIB_OLD�}�}�"�` if �`echo �{�{PERL5LIB_OLD�}�}�`'"
echo ""

perl -e 'open F, ">::macos:MacPerlTests.out"'
open ::macos:MacPerlTests.out

echo ":perl -I::lib    :base:cond.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:cond.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:if.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:if.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:lex.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:lex.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:num.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:num.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:pat.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:pat.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:rs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:rs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :base:term.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :base:term.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :cmd:elsif.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:elsif.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :cmd:for.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:for.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :cmd:mod.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:mod.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :cmd:subval.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:subval.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :cmd:switch.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:switch.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :cmd:while.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :cmd:while.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :comp:bproto.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:bproto.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:cmdopt.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:cmdopt.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:colon.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:colon.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:cpp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:cpp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:decl.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:decl.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:multiline.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:multiline.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:package.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:package.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:proto.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:proto.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:redef.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:redef.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:require.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:require.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:script.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:script.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:term.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:term.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :comp:use.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :comp:use.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :io:argv.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:argv.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:binmode.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:binmode.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:crlf.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:crlf.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:dup.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:dup.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:fflush.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:fflush.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:fs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:fs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:inplace.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:inplace.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:iprefix.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:iprefix.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:nargv.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:nargv.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:open.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:open.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:openpid.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:openpid.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:pipe.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:pipe.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:print.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:print.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:read.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:read.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:tell.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:tell.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :io:utf8.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :io:utf8.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :japh:abigail.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :japh:abigail.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :lib:1_compile.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :lib:1_compile.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :lib:commonsense.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :lib:commonsense.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :op:64bitint.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:64bitint.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:alarm.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:alarm.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:anonsub.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:anonsub.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:append.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:append.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:args.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:args.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:arith.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:arith.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:array.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:array.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:assignwarn.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:assignwarn.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:attrs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:attrs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:auto.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:auto.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:avhv.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:avhv.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:bless.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:bless.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:bop.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:bop.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:chars.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:chars.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:chdir.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:chdir.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:chop.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:chop.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:closure.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:closure.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:cmp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:cmp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:concat.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:concat.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:cond.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:cond.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:context.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:context.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:crypt.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:crypt.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:defins.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:defins.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:delete.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:delete.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:die.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:die.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:die_exit.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:die_exit.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:do.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:do.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:each.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:each.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:eval.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:eval.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:exec.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:exec.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:exists_sub.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:exists_sub.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:exp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:exp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:fh.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:fh.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:filetest.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:filetest.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:flip.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:flip.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:fork.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:fork.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:glob.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:glob.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:gmagic.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:gmagic.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:goto.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:goto.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:goto_xs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:goto_xs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:grent.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:grent.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:grep.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:grep.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:groups.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:groups.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:gv.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:gv.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:hashassign.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:hashassign.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:hashwarn.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:hashwarn.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:inc.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:inc.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:inccode.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:inccode.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:index.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:index.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:int.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:int.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:join.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:join.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:lc.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:lc.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:length.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:length.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:lex_assign.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:lex_assign.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -T :op:lfs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -T :op:lfs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:list.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:list.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:local.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:local.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:loopctl.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:loopctl.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:lop.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:lop.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:magic.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:magic.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:method.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:method.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:mkdir.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:mkdir.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:my.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:my.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:my_stash.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:my_stash.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:nothr5005.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:nothr5005.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:numconvert.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:numconvert.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:oct.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:oct.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:or.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:or.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:ord.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:ord.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:override.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:override.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:pack.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:pack.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:pat.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:pat.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:pos.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:pos.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:pow.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:pow.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:push.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:push.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:pwent.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:pwent.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:qq.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:qq.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:quotemeta.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:quotemeta.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:rand.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:rand.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:range.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:range.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:read.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:read.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:readdir.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:readdir.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:recurse.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:recurse.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:ref.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:ref.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:regexp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:regexp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:regexp_noamp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:regexp_noamp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:regmesg.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:regmesg.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:repeat.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:repeat.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:reverse.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:reverse.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:runlevel.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:runlevel.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:sleep.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:sleep.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:sort.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:sort.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:splice.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:splice.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:split.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:split.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:sprintf.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:sprintf.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:srand.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:srand.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:stat.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:stat.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -T :op:subst.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -T :op:subst.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:subst_amp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:subst_amp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:subst_wamp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:subst_wamp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:substr.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:substr.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -t :op:sub_lval.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -t :op:sub_lval.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:sysio.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:sysio.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -T :op:taint.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -T :op:taint.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:tie.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:tie.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:tiearray.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:tiearray.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:tiehandle.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:tiehandle.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:time.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:time.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -t :op:tr.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -t :op:tr.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:undef.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:undef.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:universal.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:universal.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:unshift.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:unshift.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:utf8decode.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:utf8decode.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:utfhash.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:utfhash.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:vec.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:vec.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:ver.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:ver.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:wantarray.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:wantarray.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :op:write.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :op:write.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :pod:emptycmd.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:emptycmd.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:find.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:find.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:for.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:for.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:headings.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:headings.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:include.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:include.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:included.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:included.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:lref.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:lref.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:multiline_items.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:multiline_items.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:nested_items.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:nested_items.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:nested_seqs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:nested_seqs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:oneline_cmds.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:oneline_cmds.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:plainer.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:plainer.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:pod2usage.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:pod2usage.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:poderrs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:poderrs.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:podselect.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:podselect.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :pod:special_seqs.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :pod:special_seqs.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :run:exit.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:exit.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:fresh_perl.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:fresh_perl.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:noswitch.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:noswitch.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:runenv.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:runenv.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switchF.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switchF.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switchPx.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switchPx.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switcha.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switcha.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switches.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switches.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switchn.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switchn.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switchp.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switchp.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib -t :run:switcht.t"  >> ::macos:MacPerlTests.out
:perl -I::lib -t :run:switcht.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :run:switchx.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :run:switchx.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :uni:fold.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :uni:fold.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :uni:lower.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :uni:lower.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :uni:sprintf.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :uni:sprintf.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :uni:title.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :uni:title.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :uni:upper.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :uni:upper.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :win32:longpath.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :win32:longpath.t  >> ::macos:MacPerlTests.out
echo ":perl -I::lib    :win32:system.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :win32:system.t  >> ::macos:MacPerlTests.out

echo ":perl -I::lib    :x2p:s2p.t"  >> ::macos:MacPerlTests.out
:perl -I::lib    :x2p:s2p.t  >> ::macos:MacPerlTests.out

#echo ":perl -I::lib    :op:study.t"  >> ::macos:MacPerlTests.out
#:perl -I::lib    :op:study.t  >> ::macos:MacPerlTests.out

:perl -I::lib ::macos:MacPerlTests.plx ::macos:MacPerlTests.out >> ::macos:MacPerlTests.out



echo "The following tests mostly work, but fail because of known"
echo "IO problems.  Feel free to run them, and note the failures."
echo "These tests are known to fail.  Run if you want to, but beware"
echo "because crashes are possible."
echo ""
echo "# Devel::DProf seems to work, but test needs major work :/"
echo ":perl -I::lib    :lib:dprof.t >> ::macos:MacPerlTests.out"
echo ""
echo "# fails all tests (system() fails to return a good value)"
echo ":perl -I::lib    :op:die_exit.t >> ::macos:MacPerlTests.out"
echo ""
echo "# fails test 16   (system() fails to return a good value)"
echo ":perl -I::lib    :op:magic.t >> ::macos:MacPerlTests.out"
echo ""
echo "# fails tests 129, 130, 142, 161 (known problem in sfio)"
echo ":perl -I::lib    :op:sprintf.t >> ::macos:MacPerlTests.out"
echo ""
echo "# fails tests 329 (known problem in sysopen warning)"
echo ":perl -I::lib    :pragma:warnings.t >> ::macos:MacPerlTests.out"
echo ""
echo "# `Date -t` ----- End MacPerl tests."
