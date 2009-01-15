##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

class YAMLableSubclass < Gem::Micro::YAMLable
  attr_reader :foo, :bar
end

describe "YAMLable" do
  it "should instantiate and assign the given values as instance variables" do
    obj = YAMLableSubclass[:foo => 'foo', :bar => ['bar']]
    obj.foo.should == 'foo'
    obj.bar.should == ['bar']
  end
end