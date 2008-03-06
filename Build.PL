use Module::Build;

my $build = Module::Build->new(
	module_name        => 'Symbol::Approx::Sub',
	dist_version       => '2.06',
        license            => 'perl',
        create_makefile_pl => 'traditional',
        requires           => {
		Devel::Symdump      => 0,
		Carp                => 0,
	},
        recommends         => {
		String::Approx      => 0,
		Text::Metaphone     => 0,
		Text::Soundex       => 0,
	},
        build_requires     => {
		Test::More          => 0,
	},
        build_recommends   => {
		Test::Pod           => 0,
		Test::Pod::Coverage => 0,
	},
);

$build->create_build_script;
