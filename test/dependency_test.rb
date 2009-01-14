##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)
require 'minigems'

describe "Gem::Dependency" do
  def setup
    gem_spec = Gem::SourceIndex.load_from_file(fixture('source_index.yaml')).gem_specs('rails').last
    @dependency = gem_spec.dependencies.first # rake
  end
  
  it "should return its version requirements" do
    @dependency.version_requirements.should == Gem::Requirement[:requirements => [[">=", Gem::Version[:version => '0.8.1']]]]
  end
end