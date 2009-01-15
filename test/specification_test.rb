##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Specification" do
  it "should return its dependencies" do
    gem_spec = Gem::SourceIndex.instance.gem_specs('rails').last
    expected_dep_names = %w{ rake activesupport activerecord actionpack actionmailer activeresource }
    expected_version_requirements = [[]]
    
    gem_spec.dependencies.map { |dep| dep.name }.should == expected_dep_names
  end
end