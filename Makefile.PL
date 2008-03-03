use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME       => 'Symbol::Approx::Sub',
    VERSION    => '2.03',
    PREREQ_PM => { Devel::Symdump => 0,
                   Test::More => 0,
                   Test::Pod  => 0 },
);
