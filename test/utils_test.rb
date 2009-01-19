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
  
  it "should download a file to the specified file path using curl" do
    url = 'http://gems.rubyforge.org/gems/rake-0.8.1.gem'
    path = '/tmp/rake-0.8.1.gem'
    
    expects(:system).
      with("/usr/bin/curl --silent --location --output '#{path}' #{url}").
        returns(true)
    
    curl(url, path)
  end
  
  it "should raise a DownloadError if curl failed to download the file" do
    stubs(:system).returns(false)
    lambda { curl('url', 'path') }.should.raise Gem::Micro::DownloadError
  end
  
  it "should unpack a file using tar _without_ gzip decompression" do
    path = File.join(tmpdir, 'rake-0.8.1')
    untar(fixture('rake-0.8.1.gem'), path, false)
    File.should.exist File.join(path, 'data.tar.gz')
  end
  
  it "should unpack a file using tar _with_ gzip decompression" do
    path = File.join(tmpdir, 'rake-0.8.1')
    untar(fixture('rake-0.8.1.gem'), path, false)
    
    archive = File.join(path, 'data.tar.gz')
    path = File.join(path, 'data')
    untar(archive, path, true)
    File.should.exist File.join(path, 'README')
  end
  
  it "should raise an UnpackError if tar failed to extract an archive" do
    lambda do
      untar('/does/not/exist/rake-0.8.1.gem', tmpdir, false)
    end.should.raise Gem::Micro::UnpackError
  end
end