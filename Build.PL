use Module::Build;

my $build = Module::Build->new(
	module_name        => 'Symbol::Approx::Sub',
	dist_version       => '2.05',
        license            => 'perl',
        create_makefile_pl => 'traditional',
        requires           => {
		Devel::Symdump => 0,
		Test::More     => 0,
		Test::Pod      => 0,
	}
);

$build->create_build_script;
