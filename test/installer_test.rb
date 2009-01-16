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
  
  it "should download the gem using curl" do
    url = File.join(Gem::Micro::Config[:gem_source_url], 'rake-0.8.1.gem')
    path = File.join(Gem::Micro::Config[:install_dir], 'rake-0.8.1.gem')
    @installer.expects(:system).with("/usr/bin/curl -o '#{path}' #{url}")
    
    @installer.download
  end
end