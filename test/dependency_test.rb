##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

class Gem::Dependency
  alias_method :meet_requirements?, :meets_requirements?
end

describe "Gem::Dependency" do
  def setup
    gem_spec = Gem::SourceIndex.instance.gem_specs('rails').last
    @dependencies = gem_spec.dependencies
    @dependency = @dependencies.find { |d| d.name == 'rake' }
  end
  
  it "should return its version requirements" do
    @dependency.version_requirements.should == Gem::Requirement[:requirements => [[">=", Gem::Version[:version => '0.8.1']]]]
  end
  
  it "should return whether or not its requirements are met" do
    Gem::MiniGems.stubs(:gem_paths).returns(fixture('gems'))
    @dependencies.find { |d| d.name == 'rake' }.should.meet_requirements
    @dependencies.find { |d| d.name == 'activeresource' }.should.not.meet_requirements
  end
  
  it "should return its gem spec" do
    @dependency.gem_spec.should == Gem::SourceIndex.instance.gem_specs('rake').last
    
    @dependency.version_requirements.stubs(:version).returns(Gem::Version[:version => '0.8.0'])
    @dependency.gem_spec.should == Gem::SourceIndex.instance.gem_specs('rake').first
  end
end