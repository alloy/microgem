##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

class Gem::Dependency
  alias_method :meet_requirements?, :meets_requirements?
end

xdescribe "Gem::Dependency" do
  # def setup
  #   gem_spec = Gem::Micro.source_index.gem_specs('rails').last
  #   @dependencies = gem_spec.dependencies
  #   @dependency = @dependencies.find { |d| d.name == 'rake' }
  # end
  
  it "should return its version requirements" do
    @dependency.version_requirements.should == Gem::Requirement[:requirements => [[">=", Gem::Version[:version => '0.8.1']]]]
  end
  
  it "should return whether or not its requirements are met" do
    Gem::Micro.stubs(:gem_paths).returns(fixture('gems'))
    @dependencies.find { |d| d.name == 'rake' }.should.meet_requirements
    @dependencies.find { |d| d.name == 'activeresource' }.should.not.meet_requirements
  end
  
  it "should return its gem spec matching the required version" do
    @dependency.gem_spec.should == Gem::Micro.source_index.gem_specs('rake').last
  end
  
  it "should return the latest gem spec if the required version is `0'" do
    gem_spec = Gem::Micro.source_index.gem_specs('rails').first # this has: rake >= 0
    @dependencies = gem_spec.dependencies
    @dependency = @dependencies.find { |d| d.name == 'rake' }
    
    @dependency.gem_spec.should == Gem::Micro.source_index.gem_specs('rake').last
  end
  
  it "should raise a Gem::Micro::GemSpecMissingError if the gem spec for this dependency can't be found" do
    # this has a dependency on a gem that can't be located in the source index
    gem_spec = Gem::Micro.source_index.gem_specs('test-spec-mock').first
    @dependencies = gem_spec.dependencies
    @dependency = @dependencies.find { |d| d.name == 'non-existing-gem-for-sure' }
    
    lambda { @dependency.gem_spec }.should.raise Gem::Micro::GemSpecMissingError
  end
  
  it "should return a string representation of itself" do
    @dependency.to_s.should == "rake >= 0.8.1"
  end
end