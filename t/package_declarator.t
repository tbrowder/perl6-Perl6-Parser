use v6;

use Test;
use Perl6::Tidy;

# The terms that get tested here are:

# package <name> { }
# module <name> { }
# class <name> { }
# grammar <name> { }
# role <name> { }
# knowhow <name> { }
# native <name> { }
# also is <name>
# trusts <name>
#
# class Foo { also is Int } # 'also' is a package_declaration.
# class Foo { trusts Int } # 'trusts' is a package_declaration.

# These terms either are invalid or need additional support structures.
# I'll add them momentarily...
#
# lang <name>

plan 11;

my $pt = Perl6::Tidy.new;

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{package Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
package Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{package Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{package Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{package Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
package Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{package Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{package Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit package Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit package Foo  ;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws before semi};
	}, Q{unit form};
}, Q{package};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{module Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
module Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{module Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{module Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{module Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
module Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{module Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{module Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit module Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit module Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{module};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{class Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
class Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{class Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{class Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{class Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
class Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{class Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{class Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit class Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit class Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{class};

subtest {
	plan 2;

	subtest {
		plan 2;

		my $source = Q{class Foo{also is Int}};
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{no ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo{also     is   Int}
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{ws};
}, Q{class Foo also is};

subtest {
	plan 2;

	subtest {
		plan 2;

		# space between 'Int' and {} is required
		my $source = Q{class Foo is Int {}};
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{no ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo is Int {}
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{ws};
}, Q{class Foo is};

subtest {
	plan 4;

	subtest {
		plan 2;

		my $source = Q{class Foo is repr('CStruct'){}};
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{no ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo is repr('CStruct'){}
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo is repr('CStruct') { }
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{more ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo is repr( 'CStruct' ) { }
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{even more ws};
}, Q{class Foo is repr()};

subtest {
	plan 2;

	subtest {
		plan 2;

		# space between 'Int' and {} is required
		my $source = Q{class Foo{trusts Int}};
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{no ws};

	subtest {
		plan 2;

		my $source = Q:to[_END_];
class Foo { trusts Int }
_END_
		my $p = $pt.parse-source( $source );
		my $tree = $pt.build-tree( $p );
		ok $pt.validate( $p ), Q{valid};
		is $pt.format( $tree ), $source, Q{formatted};
	}, Q{ws};
}, Q{class Foo trusts};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{grammar Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
grammar Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{grammar Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{grammar Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{grammar Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
grammar Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{grammar Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{grammar Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit grammar Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit grammar Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{grammar};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{role Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
role Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{role Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{role Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{role Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
role Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{role Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{role Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit role Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit role Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{role};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{knowhow Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
knowhow Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{knowhow Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{knowhow Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{knowhow Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
knowhow Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{knowhow Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{knowhow Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit knowhow Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit knowhow Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{knowhow};

subtest {
	plan 3;

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{native Foo{}};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
native Foo     {}
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{native Foo{}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{native Foo     {}  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{no intrabrace spacing};

	subtest {
		plan 4;

		subtest {
			plan 2;

			my $source = Q{native Foo{   }};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
native Foo     {   }
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading ws};

		subtest {
			plan 2;

			my $source = Q{native Foo{   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{trailing ws};

		subtest {
			plan 2;

			my $source = Q{native Foo     {   }  };
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{leading, trailing ws};
	}, Q{intrabrace spacing};

	subtest {
		plan 2;

		subtest {
			plan 2;

			my $source = Q{unit native Foo;};
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{no ws};

		subtest {
			plan 2;

			my $source = Q:to[_END_];
unit native Foo;
_END_
			my $p = $pt.parse-source( $source );
			my $tree = $pt.build-tree( $p );
			ok $pt.validate( $p ), Q{valid};
			is $pt.format( $tree ), $source, Q{formatted};
		}, Q{ws};
	}, Q{unit form};
}, Q{native};

# XXX 'lang Foo{}' illegal
# XXX 'unit lang Foo;' illegal

# vim: ft=perl6
