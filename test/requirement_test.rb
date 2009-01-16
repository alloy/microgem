##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Requirement" do
  def setup
    @requirement = Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]]
  end
  
  it "should be equal to one in the gem specs dependencies" do
    gem_spec = Gem::SourceIndex.instance.gem_specs('rails').last
    version_requirement = gem_spec.dependencies.first.version_requirements
    
    version_requirement.should == @requirement
  end
  
  it "should be equal if both the operator and version are equal" do
    Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]].should == @requirement
  end
  
  it "should not be equal if the operators aren't equal" do
    Gem::Requirement[:requirements => [['=', Gem::Version[:version => '0.8.1']]]].should.not == @requirement
  end
  
  it "should not be equal if the versions aren't equal" do
    Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '9.8.7']]]].should.not == @requirement
  end
  
  xit "should return its highest requirement" do
    # we haven't run into these... yet
  end
  
  it "should return its highest required version" do
    @requirement.version.should == Gem::Version[:version => '0.8.1']
  end
  
  it "should return the operator of the highest required version" do
    @requirement.operator.should == '>='
  end
  
  it "should return a string representation" do
    @requirement.to_s.should == ">= 0.8.1"
  end
end