##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::BinWrapperEmitter, in general" do
  def setup
    @emitter = Gem::Micro::BinWrapperEmitter.new('rake', 'rake')
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return the path to where the bin wrapper should be created" do
    @emitter.bin_wrapper_file.should == File.join(Config::CONFIG['bindir'], 'rake')
  end
  
  it "should return the path to where the bin wrapper should be created if there's a program prefix" do
    def @emitter.rbconfig(name)
      { 'bindir' => '/bindir', 'ruby_install_name' => 'macruby' }[name]
    end
    
    @emitter.bin_wrapper_file.should == File.join('/bindir', 'macrake')
  end
  
  it "should return the path to where the bin wrapper should be created if there's a program suffix" do
    def @emitter.rbconfig(name)
      { 'bindir' => '/bindir', 'ruby_install_name' => 'ruby19' }[name]
    end
    
    @emitter.bin_wrapper_file.should == File.join('/bindir', 'rake19')
  end
  
  it "should create an executable bin wrapper" do
    bin_file = File.join(Gem::Micro::Utils.tmpdir, 'rake')
    @emitter.stubs(:bin_wrapper_file).returns(bin_file)
    
    @emitter.create_bin_wrapper!
    File.read(bin_file).should == @emitter.to_ruby
    File.should.be.executable bin_file
  end
end

describe "Gem::Micro::BinWrapperEmitter, when emitting a wrapper" do
  def setup
    @emitter = Gem::Micro::BinWrapperEmitter.new('rake', 'raketest')
  end
  
  it "should have a shebang pointing to the current Ruby being used" do
    @emitter.to_ruby.split("\n").first.should ==
      "#!#{ File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name']) }"
  end
  
  it "should load the correct gem and bin file" do
    @emitter.to_ruby.should.match /\ngem 'rake', version\nload 'raketest'/
  end
end