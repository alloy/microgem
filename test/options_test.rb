##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Options, defaults" do
  def setup
    @options = Gem::Micro::Options.new
  end
  
  it "should have a default log level of :info" do
    @options.log_level.should == :info
  end
end

describe "Gem::Micro::Options, with options" do
  def setup
    @options = Gem::Micro::Options.new
    @options.parse(%w{ install rake --debug })
  end
  
  it "should set the log_level" do
    @options.log_level.should == :debug
  end
  
  it "should return the command and its arguments" do
    @options.command.should == 'install'
    @options.arguments.should == ['rake']
  end
end