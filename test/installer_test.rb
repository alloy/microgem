##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Installer" do
  def setup
    @gem_spec = Gem::SourceIndex.instance.gem_specs('rake').last
    @installer = Gem::Micro::Installer.new(@gem_spec)
  end
  
  it "should return the url to download the gem from" do
    @installer.url.should == "http://gems.rubyforge.org/gems/rake-0.8.1.gem"
  end
  
  it "should return the path to the install location" do
    @installer.install_location.should ==
      File.join(Gem::Micro::Config[:install_dir], 'rake-0.8.1.gem')
  end
  
  it "should download the gem using curl" do
    @installer.expects(:system).
      with("/usr/bin/curl -o '#{@installer.install_location}' #{@installer.url}")
    
    @installer.download
  end
end