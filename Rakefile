require 'rake/testtask'

HOME = File.expand_path('../tmp/gem_home', __FILE__)

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

task :default => :test

desc "Cleans the temporary development directory"
task :clean do
  rm_rf 'tmp'
end