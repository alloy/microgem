##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Utils" do
  include Gem::Micro::Utils
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  xit "should provide a proper logger" do
  end
  
  it "should ensure a directory exists" do
    dir = File.join(Dir.tmpdir, 'nice', 'and', 'deep')
    ensure_dir(dir)
    File.should.exist dir
  end
  
  it "should create a temporary directory if it doesn't exist and return it" do
    expected_path = File.join(Dir.tmpdir, 'microgem')
    
    tmpdir.should == expected_path
    File.should.exist expected_path
  end
end