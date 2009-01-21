##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Specification" do
  def setup
    @gem_spec = Marshal.load(File.read(fixture('rake-0.8.1.gemspec.marshal')))
  end
  
  it "should return its dependencies" do
    gem_spec = Marshal.load(File.read(fixture('rails-2.1.1.gemspec.marshal')))
    
    expected_version_requirements = [[]]
    expected_dep_names = %w{
      rake
      activesupport
      activerecord
      actionpack
      actionmailer
      activeresource
    }
    
    gem_spec.dependencies.map { |dep| dep.name }.should == expected_dep_names
  end
  
  it "should return its gem dirname" do
    @gem_spec.gem_dirname.should == 'rake-0.8.1'
  end
  
  it "should return its gem filename" do
    @gem_spec.gem_filename.should == 'rake-0.8.1.gem'
  end
  
  it "should install itself" do
    installer = Gem::Micro::Installer.new(@gem_spec)
    Gem::Micro::Installer.expects(:new).with(@gem_spec).returns(installer)
    installer.expects(:install!)
    
    @gem_spec.install!
  end
  
  it "should emit itself as Ruby code" do
    @gem_spec.to_ruby.should == Gem::Micro::SpecificationEmitter.new(@gem_spec).to_ruby
  end
  
  xit "should load from a `quick' spec and retrieve the larger from the gems metadata.tar.gz" do
  end
end