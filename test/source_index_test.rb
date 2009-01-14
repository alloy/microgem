##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)
require 'minigems'

describe "Gem::SourceIndex" do
  def setup
    @index = Gem::SourceIndex.load_from_file(fixture('source_index.yaml'))
  end
  
  it "should load from a YAML file" do
    @index.should.be.instance_of Gem::SourceIndex
  end
  
  it "should return a list of gem specs matching the given name" do
    gem_specs = @index.gem_specs('rails')
    gem_specs.length.should.be 2
    gem_specs.each { |gem_spec| gem_spec.name.should == 'rails' }
  end
  
  it "should not return gem specs matching only the first part of the name" do
    gem_specs = @index.gem_specs('test-spec')
    gem_specs.length.should.be 2
    gem_specs.each { |gem_spec| gem_spec.name.should.not == 'test-spec-mock' }
  end
end