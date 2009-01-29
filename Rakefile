require 'rake/testtask'

HOME = File.expand_path('../tmp/gem_home', __FILE__)

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

task :default => :test

desc "Cleans the temporary development directory"
task :clean do
  rm_rf 'tmp'
  rm_rf 'pkg'
end

directory 'pkg'

desc "Builds and installs the gem"
task :install => :pkg do
  # TODO: install gem with µgem, this is why we don't use the rake gem tasks.
  sh 'gem build microgem.gemspec && mv microgem-*.gem pkg/'
  sh 'cd pkg && sudo gem install microgem-*.gem'
end