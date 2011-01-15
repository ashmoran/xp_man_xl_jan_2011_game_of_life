require 'bundler'
Bundler.require(:default, :test)

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"))