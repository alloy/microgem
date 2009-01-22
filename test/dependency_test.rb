##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

class Gem::Dependency
  alias_method :meet_requirements?, :meets_requirements?
end

describe "Gem::Dependency" do
  def setup
    gem_spec = gem_spec_fixture('rails', '2.1.1')
    @dependencies = gem_spec.dependencies
    @dependency = @dependencies.find { |d| d.name == 'rake' }
  end
  
  it "should return its version requirements" do
    @dependency.version_requirements.should == Gem::Requirement[:requirements => [[">=", Gem::Version[:version => '0.8.1']]]]
  end
  
  it "should return whether or not its requirements are met" do
    Gem::Micro.stubs(:gem_paths).returns(fixture('gems'))
    @dependencies.find { |d| d.name == 'rake' }.should.meet_requirements
    @dependencies.find { |d| d.name == 'activeresource' }.should.not.meet_requirements
  end
  
  it "should return its gem spec matching the required version" do
    rake = gem_spec_fixture('rake', '0.8.1')
    Gem::Micro::Source.expects(:gem_spec).with('rake', @dependency.version_requirements.version).returns(rake)
    @dependency.gem_spec.should == rake
  end
  
  it "should raise a Gem::Micro::GemSpecMissingError if the gem spec for this dependency can't be found" do
    Gem::Micro::Source.stubs(:gem_spec).returns(nil)
    lambda { @dependency.gem_spec }.should.raise Gem::Micro::GemSpecMissingError
  end
  
  it "should return a string representation of itself" do
    @dependency.to_s.should == "rake >= 0.8.1"
  end
end