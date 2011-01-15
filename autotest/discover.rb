kata_dir = File.expand_path(File.dirname(__FILE__) + '/..')
$LOAD_PATH.unshift(kata_dir) unless $LOAD_PATH.include?(kata_dir)

Autotest.add_discovery { "rspec2" }
Autotest.add_discovery { "kwoon" }