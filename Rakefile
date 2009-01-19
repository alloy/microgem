require 'rake/testtask'

HOME = File.expand_path('../tmp/gem_home', __FILE__)

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
end

task :default => :test

desc "Creates the temporary directories"
task :create_tmp_dirs do
  %w{ gems specifications }.each do |gem_dir|
    mkdir_p File.join(HOME, gem_dir) rescue nil
  end
end

desc "Setup the development env data"
task :dev_data => :get_source_index

desc "Cleans the temporary gems install directory"
task :clean do
  %w{ gems specifications }.each do |gem_dir|
    dir = File.join(HOME, gem_dir)
    rm_rf dir
    mkdir_p dir
  end
end

YAML_URL = "http://gems.rubyforge.org/yaml.Z"
desc "Downloads and unpacks #{YAML_URL}"
task :get_source_index => :create_tmp_dirs do
  require 'zlib'
  Dir.chdir(HOME) do
    sh "curl -L -O #{YAML_URL}"
    yaml = Zlib::Inflate.inflate(File.read("yaml.Z"))
    File.open("source_index.yaml", 'w') { |f| f << yaml }
  end
end

MARSHAL_URL = "http://gems.rubyforge.org/Marshal.4.8.Z"
desc "Downloads and unpacks #{MARSHAL_URL}"
task :get_marshaled_source_index => :create_tmp_dirs do
  require 'zlib'
  Dir.chdir(HOME) do
    sh "curl -L -O #{MARSHAL_URL}"
    yaml = Zlib::Inflate.inflate(File.read("Marshal.4.8.Z"))
    File.open("Marshal.4.8", 'w') { |f| f << yaml }
  end
end

desc "Copies a source index file tree to the gems site dir"
task :copy_source_index_to_site do
  require 'rbconfig'
  sitelibdir = ::Config::CONFIG['sitelibdir']
  version = ::Config::CONFIG['ruby_version']
  dir = File.expand_path("../../Gems/#{version}", sitelibdir)
  sh "cp -R '#{File.join(HOME, 'microgem_source_index')}' '#{dir}'"
end