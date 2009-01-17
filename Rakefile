require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

task :default => :test

desc "Creates the temporary directories"
task :create_tmp_dirs do
  mkdir_p "tmp/gems" rescue nil
end

desc "Setup the development env data"
task :dev_data => :get_source_index

desc "Cleans the temporary gems install directory"
task :clean do
  rm_rf "tmp/gems"
  mkdir_p "tmp/gems"
end

YAML_URL = "http://gems.rubyforge.org/yaml.Z"
desc "Downloads and unpacks #{YAML_URL}"
task :get_source_index => :create_tmp_dirs do
  require 'zlib'
  Dir.chdir('tmp') do
    sh "curl -L -O #{YAML_URL}"
    yaml = Zlib::Inflate.inflate(File.read("yaml.Z"))
    File.open("source_index.yaml", 'w') { |f| f << yaml }
  end
end