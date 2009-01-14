##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)
require 'minigems'

describe "Gem::Version" do
  it "should be equal if the versions is equal" do
    Gem::Version[:version => '0.1.2'].should == Gem::Version[:version => '0.1.2']
  end
  
  it "should not be equal if the versions aren't equal" do
    Gem::Version[:version => '0.1.2'].should.not == Gem::Version[:version => '0.1.3']
  end
end