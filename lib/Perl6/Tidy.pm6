=begin pod

=begin NAME

Perl6::Tidy - Extract a Perl 6 AST from the NQP Perl 6 Parser

=end NAME

=begin SYNOPSIS

    my $pt = Perl6::Tidy.new;
    my $parsed = $pt.tidy( Q:to[_END_] );
    say $parsed.perl6($format-settings); 
    my $other = $pt.tidy-file( 't/clean-me.t' );

    # This *will* execute phasers such as BEGIN in your existing code.
    # This may constitute a security hole, at least until the author figures
    # out how to truly make the Perl 6 grammar standalone.

=end SYNOPSIS

=begin DESCRIPTION

Uses the built-in Perl 6 parser exposed by the nqp module in order to parse Perl 6 from within Perl 6. If this scares you, well, it probably should. Once this is finished, you should be able to call C<.perl6> on the tidied output, along with a so-far-unspecified formatting object, and get back nicely-formatted Perl 6 code.

Please B<please> note that this, out of necessity, does compile your Perl 6 code, which B<does> mean executing phasers such as C<BEGIN>. There may be a way to oerride this behavior, and if you have suggestions that don't involve rewriting the Perl 6 grammar as a standalone library (which would not be such a bad idea in general) then please let the author know.

As it stands, the C<.tidy> method returns a deeply-nested object representation of the Perl 6 code it's given. It handles the regex language, but not the other braided languages such as embedded blocks in strings. It will do so eventually, but for the moment I'm busy getting the grammar rules covered.

While classes like L<EClass> won't go away, their parent classes like L<DecInteger> will remove them from the tree once their validation job has been done. For example, while the internals need to know that L<< $/<eclass> >> (the exponent for a scientific-notation number) hasn't been renamed or moved elsewhere in the tree, you as a consumer of the L<DecInteger> class don't need to know that. The C<DecInteger.perl6> method will delete the child classes so that we don't end up with a B<horribly> cluttered tree.

Classes representing Perl 6 object code are currently in the same file as the main L<Perl6::Tidy> class, as moving them to separate files caused a severe performance penalty. When the time is right I'll look at moving these to another location, but as shuffling out 20 classes increased my runtime on my little ol' VM from 6 to 20 seconds, it's not worth my time to break them out. And besides, having them all in one file makes editing en masse easier.

=end DESCRIPTION

=begin METHODS

=item tidy( Str $perl-code ) returns Perl6::Tidy::Root

Given a Perl 6 code string, return the class structure, so you can see the parse tree in action. This is mostly because the internal L<Perl6::Tidy> objects are poorly named.

=item perl6( Hash %format-settings ) returns Str

Given a so-far undefined hash of format settings, return formatted Perl 6 code to meet the user's expectations.

=end METHODS

=end pod

# These debugging routines are rather hit-and-miss because the objects they're
# supposed to silly-walk aren't actually Perl, but a lower-level object.
#
# I do need to firm them up before releasing.
#
sub dump-parsed( Mu $parsed ) {
	my @lines;
	my @types;
	@types.push( 'Bool' ) if $parsed.Bool;
	@types.push( 'Int'  ) if $parsed.Int;
	@types.push( 'Num'  ) if $parsed.Num;

	@lines.push( Q[ ~:   '] ~ ~$parsed.Str ~ "' - Types: " ~ @types.gist );
	@lines.push( Q[{}:    ] ~ $parsed.hash.keys.gist );
	# XXX
	CATCH { default { .resume } } # workaround for X::Hash exception
	@lines.push( Q{[]:    } ~ $parsed.list.elems );

	if $parsed.hash {
		my @keys;
		for $parsed.hash.keys {
			@keys.push( $_ ) if
				$parsed.hash:defined{$_} and not
				$parsed.hash.{$_}
		}
		@lines.push( Q[{}:U: ] ~ @keys.gist );

		for $parsed.hash.keys {
			next unless $parsed.hash.{$_};
			@lines.push( qq{  {$_}:  } );
			@lines.append( dump-parsed( $parsed.hash.{$_} ) )
		}
	}
	if $parsed.list {
		my $i = 0;
		for $parsed.list {
			@lines.push( qq{  [$i]:  } );
			@lines.append( dump-parsed( $_ ) )
		}
	}

	my $indent-str = '  ';
	map { $indent-str ~ $_ }, @lines
}

sub dump( Mu $parsed ) {
	dump-parsed( $parsed ).join( "\n" )
}

use Perl6::Tidy::Validator;
use Perl6::Tidy::Factory;

class Perl6::Tidy {
	use nqp;

	# These could easily be a single method, but I'll separate them for
	# testing purposes.
	#
	method parse-source( Str $source ) {
		my $*LINEPOSCACHE;
		my $compiler := nqp::getcomp('perl6');
		my $g := nqp::findmethod($compiler,'parsegrammar')($compiler);
		#$g.HOW.trace-on($g);
		my $a := nqp::findmethod($compiler,'parseactions')($compiler);

		my $parsed = $g.parse(
			$source,
			:p( 0 ),
			:actions( $a )
		);

		return $parsed
	}

	method validate( Mu $parsed ) {
		my $validator = Perl6::Tidy::Validator.new;
		my $res       = $validator.validate( $parsed );

		die "Validation failed!" if !$res and %*ENV<AUTHOR_TESTS>;

		$res
	}

	method build-tree( Mu $parsed ) {
		my $factory = Perl6::Tidy::Factory.new;
		my $tree    = $factory.build( $parsed );

		self.check-tree( $tree );
		$tree
	}

	method check-tree( Perl6::Element $root ) {
		if $root.^can('delimiter') {
			unless $root.delimiter.[0] {
				say $root.perl;
				die "Opening delimiter missing" 
			}
			unless $root.delimiter.[1] {
				say $root.perl;
				die "Closing delimiter missing" 
			}
		}
		if $root.^can('child') {
			for $root.child {
				self.check-tree( $_ );
				unless $_.^can('from') {
					say $_.perl;
					note "Element in list does not have 'from' accessor"
				}
			}
			if $root.child.elems > 1 {
				for $root.child.kv -> $index, $_ {
					next if $index == 0;
					next unless $root.child.[$index-1].^can('to');
					next unless $root.child.[$index].^can('from');
					if $root.child.[$index-1] ~~ Perl6::WS and
					   $root.child.[$index] ~~ Perl6::WS {
#						say $root.child.[$index-1].perl;
#						say $root.child.[$index].perl;
						say "Two WS entries in a row"
					}
					if $root.child.[$index-1].to !=
						$root.child.[$index].from {
#						say $root.child.[$index-1].perl;
#						say $root.child.[$index].perl;
						say "Gap between two items"
					}
				}
			}
		}
		if $root.^can('content') {
			if $root.content.chars < $root.to - $root.from {
				say $root.perl;
				die "Content '{$root.content}' too short for element ({$root.from} - {$root.to})"
			}
			if $root.content.chars > $root.to - $root.from {
				say $root.perl;
				die "Content '{$root.content}' too long for element ({$root.from} - {$root.to})"
			}
			if $root !~~ Perl6::WS and
					$root.content ~~ m{ ^ (\s+) } {
				say $root.perl;
				die "Content '{$root.content}' has leading whitespace"
			}
			if $root !~~ Perl6::WS and
					$root.content ~~ m{ (\s+) $ } {
				say $root.perl;
				die "Content '{$root.content}' has trailing whitespace"
			}
		}
	}

	method format( $tree, $formatting = { } ) {
		my $str = $tree.perl6( $formatting );

		$str
	}

	method dump-term( Perl6::Element $term ) {
		my $str = $term.WHAT.perl;
		if $term ~~ Perl6::Block or
		   $term ~~ Perl6::Operator::Circumfix or
		   $term ~~ Perl6::Operator::PostCircumfix {
			$str ~= " ('{$term.delimiter.[0]}'..'{$term.delimiter.[1]}')"
		}
		elsif $term ~~ Perl6::Bareword or
		      $term ~~ Perl6::Variable or
		      $term ~~ Perl6::Operator or
		      $term ~~ Perl6::WS {
			$str ~= " ({$term.content.perl})"
		}
		elsif $term ~~ Perl6::Number {
			$str ~= " ({$term.content})"
		}
		elsif $term ~~ Perl6::String {
			$str ~= " ({$term.content}) ('{$term.bare}')"
		}

		if $term.^can('from') and not (
				$term ~~ Perl6::Document | Perl6::Statement
			) {
			$str ~= " ({$term.from}-{$term.to})";
		}
		$str
	}

	method dump-tree( Perl6::Element $root,
			  Bool $display-ws = True,
			  Int $depth = 0 ) {
		return '' if $root ~~ Perl6::WS and !$display-ws;
		my $str = ( "\t" xx $depth ) ~ self.dump-term( $root ) ~ "\n";
		if $root.^can('child') {
			for $root.child {
				$str ~= self.dump-tree( $_, $display-ws, $depth + 1 )
			}
		}
		$str
	}

	method ruler( Str $source ) {
		my Str $munged = substr( $source, 0, min( $source.chars, 72 ) );
		$munged ~= '...' if $source.chars > 72;
		my Int $blocks = $munged.chars div 10 + 1;
		$munged ~~ s:g{ \n } = Q{␤};
		my Str $nums = '';
		for ^$blocks {
			$nums ~= "         {$_+1}";
		}

		my $ruler = '';
		$ruler ~= '#' ~ ' ' ~ $nums ~ "\n";
		$ruler ~= '#' ~ ('0123456789' x $blocks) ~ "\n";
		$ruler ~= '#' ~ $munged ~ "\n";
	}

	method tidy( Str $source, $formatting = { } ) {
		my $parsed    = self.parse-source( $source );
		my $valid     = self.validate( $parsed );
		my $tree      = self.build-tree( $parsed );
		my $formatted = self.format( $tree, $formatting );

		$formatted
	}
}
