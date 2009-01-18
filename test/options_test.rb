##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Options, defaults" do
  def setup
    @options = Gem::Micro::Options.new
  end
  
  it "should have a default log level of :info" do
    @options.log_level.should == :info
  end
  
  it "should not force commands by default" do
    assert !@options.force
  end
end

describe "Gem::Micro::Options, with options" do
  def setup
    @options = Gem::Micro::Options.new
  end
  
  it "should set the log_level" do
    @options.parse(%w{ install rake --debug }).log_level.should == :debug
  end
  
  it "should force commands" do
    assert @options.parse(%w{ install rake --force }).force
  end
  
  it "should return the command and its arguments" do
    @options.parse(%w{ install rake --debug })
    @options.command.should == 'install'
    @options.arguments.should == ['rake']
  end
end