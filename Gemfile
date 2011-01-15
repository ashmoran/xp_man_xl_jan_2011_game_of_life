source :rubygems

# No gems in the default group...

group :test do
  gem "rspec", ">= 2.0.0.rc"
end

group :install_only do
  gem "autotest"
  gem "autotest-fsevent" if RUBY_PLATFORM =~ /darwin/
end