##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

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
  
  it "should return the matching gem specs sorted by version" do
    def @index.gems # stub #gems to return the gems in reverse order
      @gems.to_a.sort_by { |_, spec| spec.version.to_s }.reverse
    end
    
    @index.gem_specs('rails').map { |s| s.version.to_s }.should == %w{ 2.1.0 2.1.1 }
  end
end