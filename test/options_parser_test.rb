##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Options, with options" do
  def setup
    @parser = Gem::Micro::OptionsParser.new
  end
  
  it "should set the log_level" do
    @parser.parse(%w{ install rake --debug }).options.should == { :log_level => :debug }
  end
  
  it "should force commands" do
    @parser.parse(%w{ install rake --force }).options.should == { :force => true }
  end
  
  it "should enable the simple downloader" do
    @parser.parse(%w{ install rake --simple-downloader }).options.should == { :simple_downloader => true }
  end
  
  it "should enable the simple unpacker" do
    @parser.parse(%w{ install rake --simple-unpacker }).options.should == { :simple_unpacker => true }
  end
  
  it "should enable the simple downloader and unpacker" do
    @parser.parse(%w{ install rake --simple }).options.should ==
      { :simple_downloader => true, :simple_unpacker => true }
  end
  
  it "should return the command and its arguments" do
    @parser.parse(%w{ install rake --debug })
    @parser.command.should == 'install'
    @parser.arguments.should == ['rake']
  end
end