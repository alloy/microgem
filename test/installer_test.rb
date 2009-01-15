##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Installer" do
  it "should return the url to download the gem from" do
    gem_spec = Gem::SourceIndex.instance.gem_specs('rake').last
    Gem::Micro::Installer.new(gem_spec).url.should == "http://gems.rubyforge.org/gems/rake-0.8.1.gem"
  end
end