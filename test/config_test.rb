##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Config" do
  include Gem::Micro::Utils
  
  def teardown
    ENV.delete('PRODUCTION')
  end
  
  it "should return the path to the development gem_home in development mode" do
    config.gem_home.should == File.expand_path("../../tmp/gem_home", __FILE__)
  end
  
  it "should return the path to the real rubygems gem_home in production mode" do
    ENV['PRODUCTION'] = 'true'
    config.gem_home.should == rubygems_gem_paths.first
  end
  
  it "should return a list of the available sources" do
    config.sources.should == %w{ gems.rubyforge.org gems.github.com }
  end
  
  private
  
  def rubygems_gem_paths
    YAML.load(`gem env`)["RubyGems Environment"].find { |h| h.has_key? 'GEM PATHS' }['GEM PATHS']
  end
end