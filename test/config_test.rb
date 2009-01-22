##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Config" do
  include Gem::Micro::Utils
  
  def teardown
    ENV.delete('PRODUCTION')
    config.instance_variable_set(:@gem_home, nil)
    config.instance_variable_set(:@bin_dir, nil)
    config.merge! :log_level => :info, :force => false, :simple_downloader => false, :simple_unpacker => false
  end
  
  it "should return the path to the development gem_home in development mode" do
    config.instance_variable_set(:@gem_home, nil)
    path = File.expand_path("../../tmp/gem_home", __FILE__)
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.gem_home.should == path
  end
  
  it "should return the path to the real rubygems gem_home in production mode" do
    ENV['PRODUCTION'] = 'true'
    path = rubygems_gem_paths.first
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.gem_home.should == path
  end
  
  it "should return the path to the bin dir in development mode" do
    path = File.expand_path("../../tmp/bin", __FILE__)
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.bin_dir.should == path
  end
  
  it "should return the path to the bin dir in production mode which should exist" do
    ENV['PRODUCTION'] = 'true'
    path = Config::CONFIG['bindir']
    
    config.expects(:ensure_dir).never
    config.bin_dir.should == path
  end
  
  it "should return a list of the available sources" do
    config.sources.should == %w{ gems.rubyforge.org gems.github.com }
  end
  
  it "should return the path to the gems path" do
    path = File.join(config.gem_home, 'gems')
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.gems_path.should == path
  end
  
  it "should return the path to the specifications path" do
    path = File.join(config.gem_home, 'specifications')
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.specifications_path.should == path
  end
  
  it "should return the path to the gem cache path" do
    path = File.join(config.gem_home, 'cache')
    
    config.expects(:ensure_dir).with(path).returns(path)
    config.cache_path.should == path
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