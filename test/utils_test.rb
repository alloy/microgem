##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Utils" do
  include Gem::Micro::Utils
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should ensure a directory exists and return it" do
    dir = File.join(Dir.tmpdir, 'nice', 'and', 'deep')
    ensure_dir(dir).should == dir
    File.should.exist dir
  end
  
  it "should remove an existing directory (or file) before moving a new directory to the location" do
    old_dir = File.join(Dir.tmpdir, 'existing_directory')
    new_dir = File.join(Dir.tmpdir, 'new_directory')
    ensure_dir(old_dir)
    ensure_dir(new_dir)
    
    file_in_old_dir = File.join(old_dir, 'file')
    File.open(file_in_old_dir, 'w') { |f| f << 'foo' }
    
    replace(new_dir, old_dir)
    File.should.exist old_dir
    File.should.not.exist file_in_old_dir
  end
  
  it "should create a temporary directory if it doesn't exist and return it" do
    expected_path = File.join(Dir.tmpdir, 'microgem')
    
    tmpdir.should == expected_path
    File.should.exist expected_path
  end
  
  it "should return Gem::Micro::Config.instance" do
    config.should.be Gem::Micro::Config
  end
end