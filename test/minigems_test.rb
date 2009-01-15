##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::MiniGems" do
  def setup
    Gem::MiniGems.stubs(:gem_paths).returns(fixture('gems'))
  end
  
  it "should return an array of all installed gems" do
    Gem::MiniGems.installed_gem_dirnames.should ==
      %w{ rake-0.8.0 rake-0.8.1 test-spec-0.3.0 test-spec-mock-0.3.0 }
  end
  
  it "should return an array of all installed gems matching the given name" do
    Gem::MiniGems.installed_gem_dirnames('rake').should == %w{ rake-0.8.0 rake-0.8.1 }
    Gem::MiniGems.installed_gem_dirnames('test-spec').should == %w{ test-spec-0.3.0 }
    Gem::MiniGems.installed_gem_dirnames('test-spec-mock').should == %w{ test-spec-mock-0.3.0 }
  end
end