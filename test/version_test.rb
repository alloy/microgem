##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Version" do
  it "should be comparable" do
    Gem::Version[:version => '0.1.2'].should == Gem::Version[:version => '0.1.2']
    Gem::Version[:version => '0.1.2'].should.not == Gem::Version[:version => '0.1.3']
    
    Gem::Version[:version => '0.1.2'].should >= Gem::Version[:version => '0.1.1']
    Gem::Version[:version => '0.1.2'].should >= Gem::Version[:version => '0.1.2']
    
    Gem::Version[:version => '0.1.2'].should <= Gem::Version[:version => '0.1.2']
    Gem::Version[:version => '0.1.1'].should <= Gem::Version[:version => '0.1.2']
  end
  
  it "should instantiate from a gem directory name" do
    Gem::Version.from_gem_dirname('rake-0.8.1').should == Gem::Version[:version => '0.8.1']
    Gem::Version.from_gem_dirname('rake').should.be nil
  end
  
  it "should return if any version would be good or not" do
    assert Gem::Version[:version => '0'].any?
    assert Gem::Version[:version => 0].any?
    assert !Gem::Version[:version => '0.1.2'].any?
  end
end