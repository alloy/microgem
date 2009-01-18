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
  
  it "should load the source_index.yaml file if no microgem_source_index exists" do
    without_source_index do
      File.stubs(:exist?).returns(false)
      
      Gem::SourceIndex.expects(:load_from_file).
        with(Gem::Micro::Config[:source_index_path])
      
      Gem::Micro.source_index
    end
  end
  
  it "should load a SourceIndexFileTree file if microgem_source_index exists" do
    without_source_index do
      File.stubs(:exist?).returns(true)
      
      Gem::Micro::SourceIndexFileTree.expects(:new).
        with(Gem::Micro::Config[:microgem_source_index])
      
      Gem::Micro.source_index
    end
  end
  
  it "should start the installation process of a gem" do
    gem_spec = Gem::Micro.source_index.gem_specs('rake').last
    Gem::SourceIndex.instance.expects(:gem_specs).with('rake').returns([gem_spec])
    gem_spec.expects(:install!)
    
    Gem::Micro.run(%w{ install rake })
  end
  
  it "should update the source index cache" do
    Gem::Micro.stubs(:load_source_index)
    
    root = File.join(Gem::Micro::Config[:gem_home], 'microgem_source_index')
    
    File.stubs(:exist?).with(root).returns(true)
    FileUtils.expects(:rm_rf).with(root)
    Gem::Micro::SourceIndexFileTree.expects(:create).with(root, Gem::SourceIndex.instance)
    
    Gem::Micro.run(%w{ cache update })
  end
  
  private
  
  def without_source_index
    before = Gem::Micro.source_index
    Gem::Micro.instance_variable_set(:@source_index, nil)
    yield
  ensure
    Gem::Micro.instance_variable_set(:@source_index, before)
  end
end