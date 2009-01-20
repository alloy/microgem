##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Unpacker, in simple mode" do
  include Gem::Micro::Utils
  
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
  
end