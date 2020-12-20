use Test::More;
eval "use Test::Pod 1.52";
plan skip_all => "Test::Pod 1.52 required for testing POD" if $@;
all_pod_files_ok();
