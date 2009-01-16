##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro" do
  def setup
    Gem::Micro.stubs(:gem_paths).returns(fixture('gems'))
  end
  
  it "should return an array of all installed gems" do
    Gem::Micro.installed_gem_dirnames.should ==
      %w{ rake-0.8.0 rake-0.8.1 test-spec-0.3.0 test-spec-mock-0.3.0 }
  end
  
  it "should return an array of all installed gems matching the given name" do
    Gem::Micro.installed_gem_dirnames('rake').should == %w{ rake-0.8.0 rake-0.8.1 }
    Gem::Micro.installed_gem_dirnames('test-spec').should == %w{ test-spec-0.3.0 }
    Gem::Micro.installed_gem_dirnames('test-spec-mock').should == %w{ test-spec-mock-0.3.0 }
  end
  
  it "should load the source_index.yaml file" do
    Gem::SourceIndex.expects(:load_from_file).with(Gem::Micro::Config[:source_index_path])
    Gem::Micro.load_source_index
  end
  
  it "should run the command as specified in the arguments" do
    url = File.join(Gem::Micro::Config[:gem_source_url], 'rake-0.8.1.gem')
    path = File.join(Gem::Micro::Config[:install_dir], 'rake-0.8.1.gem')
    Gem::Micro::Installer.any_instance.expects(:system).with("/usr/bin/curl -o '#{path}' #{url}")
    
    Gem::Micro.run("install", "rake")
  end
end