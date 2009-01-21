##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Unpacker, in simple mode" do
  include Gem::Micro::Utils
  
  def setup
    config.stubs(:simple_unpacker?).returns(true)
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should unpack a file using tar _without_ gzip decompression" do
    path = File.join(tmpdir, 'rake-0.8.1')
    Gem::Micro::Unpacker.tar(fixture('rake-0.8.1.gem'), path, false)
    File.should.exist File.join(path, 'data.tar.gz')
  end
  
  it "should unpack a file using tar _with_ gzip decompression" do
    path = File.join(tmpdir, 'rake-0.8.1')
    Gem::Micro::Unpacker.tar(fixture('rake-0.8.1.gem'), path, false)
    
    archive = File.join(path, 'data.tar.gz')
    path = File.join(path, 'data')
    Gem::Micro::Unpacker.tar(archive, path, true)
    File.should.exist File.join(path, 'README')
  end
  
  it "should raise an UnpackError if tar failed to extract an archive" do
    lambda do
      Gem::Micro::Unpacker.tar('/does/not/exist/rake-0.8.1.gem', tmpdir, false)
    end.should.raise Gem::Micro::Unpacker::UnpackError
  end
  
  it "should unpack a file using gunzip" do
    dir = File.join(tmpdir, 'specs')
    ensure_dir(dir)
    FileUtils.cp(fixture('specs.4.8.gz'), dir)
    
    Gem::Micro::Unpacker.gzip(File.join(dir, 'specs.4.8.gz'))
    File.should.exist File.join(dir, 'specs.4.8')
    Marshal.load(File.read(File.join(dir, 'specs.4.8'))).should.be.instance_of Array
  end
  
  it "should raise an UnpackError if gunzip failed to extract an archive" do
    lambda do
      Gem::Micro::Unpacker.gzip('/does/not/exist/specs.4.8.gz')
    end.should.raise Gem::Micro::Unpacker::UnpackError
  end
  
  it "should unpack a Z archive using bin/zinflate" do
    zinflate = File.expand_path('../../bin/zinflate', __FILE__)
    archive = fixture('rake-0.8.1.gemspec.rz')
    out_file = File.join(tmpdir, 'marshalled_gemspec')
    
    Gem::Micro::Unpacker.expects(:inflate_with_zlib).never
    Gem::Micro::Unpacker.inflate(archive, out_file)
    Marshal.load(File.read(out_file)).should.be.instance_of Gem::Specification
  end
  
  it "should raise an UnpackError if zinflate failed to extract an archive" do
    lambda do
      Gem::Micro::Unpacker.inflate('/does/not/exist/rake-0.8.1.gemspec.rz', '/tmp')
    end.should.raise Gem::Micro::Unpacker::UnpackError
  end
end

describe "Unpacker, in complex mode" do
  include Gem::Micro::Utils
  
  def setup
    config.stubs(:simple_unpacker?).returns(false)
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should inflate a Z archive using Ruby's Zlib" do
    out_file = File.join(tmpdir, 'marshalled_gemspec')
    Gem::Micro::Unpacker.inflate(fixture('rake-0.8.1.gemspec.rz'), out_file)
    Marshal.load(File.read(out_file)).should.be.instance_of Gem::Specification
  end
end