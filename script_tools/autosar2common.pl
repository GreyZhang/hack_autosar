#!/usr/bin/perl -w

use File::Find;

find(\&process_c_code_file, '.');

sub process_c_code_file
{
	if(/\.c$|\.h$/)
	{
		if($_ ne "Compiler.h")
		{
			open(CODE, "<$_");
			my @code = <CODE>;
			close CODE;
			my $code = join '',@code;

			$code =~ s/CONSTP2FUNC\((\w+)\s*,\s*\w+\)/$1 (* const )/g;
			$code =~ s/P2FUNC\((\w+)\s*,\s*\w+\)/$1 (*fctname)/g;
			$code =~ s/FUNC\((\w+)\s*,\s*\w+\)/$1/g;
			$code =~ s/CONSTP2VAR\((\w+)\s*,\s*\w+,\s*\w+\)/$1 * const/g;
			$code =~ s/CONSTP2CONST\((\w+)\s*,\s*\w+,\s*\w+\)/const $1 * const/g;
			$code =~ s/P2CONST\((\w+)\s*,\s*\w+,\s*\w+\)/const $1 */g;
			$code =~ s/P2VAR\((\w+)\s*,\s*\w+,\s*\w+\)/$1 */g;

			open(CODE, ">$_");
			print CODE "$code";
			close CODE;
		}
	}
}
