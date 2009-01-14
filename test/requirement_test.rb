##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)
require 'minigems'

describe "Gem::Requirement" do
  it "should be equal to one in the gem specs dependencies" do
    gem_spec = Gem::SourceIndex.load_from_file(fixture('source_index.yaml')).gem_specs('rails').last
    requirement = gem_spec.dependencies.first.version_requirements
    
    requirement.should == Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]]
  end
  
  it "should be equal if both the operator and version are equal" do
    Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.1.2']]]].should ==
      Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.1.2']]]]
  end
  
  it "should not be equal if the operators aren't equal" do
    Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.1.2']]]].should.not ==
      Gem::Requirement[:requirements => [['=>', Gem::Version[:version => '0.1.2']]]]
  end
  
  it "should not be equal if the versions aren't equal" do
    Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.1.2']]]].should.not ==
      Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.1.3']]]]
  end
end