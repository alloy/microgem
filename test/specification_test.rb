##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)
require 'minigems'

describe "Gem::Specification" do
  def setup
    @gem_spec = Gem::SourceIndex.load_from_file(fixture('source_index.yaml')).gem_specs('rails').last
  end
  
  it "should return its dependencies" do
    expected_dep_names = %w{ rake activesupport activerecord actionpack actionmailer activeresource }
    expected_version_requirements = [[]]
    @gem_spec.dependencies.map { |dep| dep.name }.should == expected_dep_names
  end
end