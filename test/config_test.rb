##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Config" do
  include Gem::Micro::Utils
  
  def teardown
    ENV.delete('PRODUCTION')
    config.instance_variable_set(:@gem_home, nil)
    config.merge! :log_level => :info, :force => false, :simple_downloader => false, :simple_unpacker => false
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
  
  it "should return the path to the gems path" do
    config.gems_path.should == File.join(config.gem_home, 'gems')
  end
  
  it "should return the path to the specifications path" do
    config.specifications_path.should == File.join(config.gem_home, 'specifications')
  end
  
  it "should return the path to the gem cache path" do
    config.cache_path.should == File.join(config.gem_home, 'cache')
  end
  
  it "should return the log_level" do
    config.log_level.should == :info
  end
  
  it "should return whether or not to force actions" do
    assert !config.force?
  end
  
  it "should return whether or not to use the simple (external) downloader" do
    assert !config.simple_downloader?
  end
  
  it "should return whether or not to use the simple (external) unpacker" do
    assert !config.simple_unpacker?
  end
  
  it "should merge a hash of config values" do
    config.merge! :log_level => :debug, :force => true, :simple_downloader => true, :simple_unpacker => true
    
    config.log_level.should == :debug
    assert config.force?
    assert config.simple_downloader?
    assert config.simple_unpacker?
  end
  
  private
  
  def rubygems_gem_paths
    YAML.load(`gem env`)["RubyGems Environment"].find { |h| h.has_key? 'GEM PATHS' }['GEM PATHS']
  end
end