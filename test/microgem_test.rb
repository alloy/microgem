##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro" do
  def setup
    Gem::Micro::Config.stubs(:gems_path).returns(fixture('gems'))
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
  
  xit "should start the installation process of a gem" do
    gem_spec = Gem::Micro.source_index.gem_specs('rake').last
    Gem::SourceIndex.instance.expects(:gem_specs).with('rake').returns([gem_spec])
    gem_spec.expects(:install!)
    
    Gem::Micro.run(%w{ install rake })
  end
  
  it "should update the source indices" do
    Gem::Micro::Source.expects(:update!)
    Gem::Micro.run(%w{ sources update })
  end
end