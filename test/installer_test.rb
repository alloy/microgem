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
  
  it "should download the gem with curl" do
    def @installer.system(command)
      @command = command
    end
    
    @installer.download_to('/path/to/download/dir')
    @installer.instance_variable_get(:@command).should ==
      "/usr/bin/curl -o '/path/to/download/dir/rake-0.8.1.gem' #{@installer.url}"
  end
end