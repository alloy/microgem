##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Installer, in general" do
  def setup
    @gem_spec = Gem::Micro.source_index.gem_specs('rake').last
    @installer = Gem::Micro::Installer.new(@gem_spec)
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return the url to download the gem from" do
    @installer.url.should == "http://gems.rubyforge.org/gems/rake-0.8.1.gem"
  end
  
  it "should return the path to the install path" do
    @installer.install_path.should ==
      File.join(Gem::Micro::Config[:install_dir], 'rake-0.8.1')
  end
  
  it "should return the path to the gem in the temporary work directory" do
    @installer.work_dir.should ==
      File.join(Gem::Micro::Utils.tmpdir, 'rake-0.8.1')
  end
  
  it "should return the path to the gems data directory in the temporary directory" do
    @installer.data_dir.should ==
      File.join(@installer.work_dir, 'data')
  end
  
  it "should return the path to the gems data archive in the temporary directory" do
    @installer.data_file.should ==
      File.join(@installer.work_dir, 'data.tar.gz')
  end
  
  it "should download the gem to the work directory using curl" do
    @installer.expects(:system).
      with("/usr/bin/curl --silent --location --output '#{@installer.gem_file}' #{@installer.url}").
        returns(true)
    
    @installer.download
  end
  
  it "should raise a DownloadError if curl failed to download the gem" do
    @installer.stubs(:system).returns(false)
    lambda { @installer.download }.should.raise Gem::Micro::Installer::DownloadError
  end
  
  it "should unpack the gem using tar" do
    @installer.stubs(:gem_file).returns(fixture('rake-0.8.1.gem'))
    
    @installer.unpack
    File.should.exist File.join(@installer.work_dir, 'data', 'README')
  end
  
  it "should raise an UnpackError if tar failed to extract an archive" do
    lambda do
      @installer.send(:untar, '/does/not/exist/rake-0.8.1.gem', @installer.work_dir, false)
    end.should.raise Gem::Micro::Installer::UnpackError
  end
  
  it "should return the path to the Ruby `.gemspec' file" do
    @installer.ruby_gemspec_file.should ==
      File.join(Gem::Micro::Config[:gem_home], 'specifications', 'rake-0.8.1.gemspec')
  end
  
  it "should create a `.gemspec' file so RubyGems can find the gem" do
    FileUtils.mkdir_p(File.dirname(@installer.ruby_gemspec_file))
    @installer.create_ruby_gemspec!
    
    File.read(@installer.ruby_gemspec_file).should == @gem_spec.to_ruby
  end
end

describe "Gem::Micro::Installer.install" do
  def setup
    @gem_spec = Gem::Micro.source_index.gem_specs('rake').last
    @installer = Gem::Micro::Installer.new(@gem_spec)
    @installer.stubs(:download)
    @installer.stubs(:unpack)
    FileUtils.stubs(:mv)
  end
  
  it "should install its dependencies that are not installed yet" do
    @gem_spec = Gem::Micro.source_index.gem_specs('rails').last
    @installer.instance_variable_set(:@gem_spec, @gem_spec)
    
    Gem::Micro.stubs(:gem_paths).returns(fixture('gems'))
    
    @gem_spec.dependencies.each do |dep|
      if dep.name == 'rake'
        dep.gem_spec.expects(:install!).never
      else
        dep.gem_spec.expects(:install!).once
      end
    end
    
    @installer.install!
  end
  
  it "should download the gem" do
    @installer.expects(:download)
    @installer.install!
  end
  
  it "should unpack the gem" do
    @installer.expects(:unpack)
    @installer.install!
  end
  
  it "should move the unpacked data directory of the gem to install_path" do
    FileUtils.expects(:mv).with(@installer.data_dir, @installer.install_path)
    @installer.install!
  end
  
  it "should skip the actual installation of the gem _if_ after installing the dependencies it exists" do
    File.expects(:exist?).with(@installer.install_path).returns(true)
    @installer.expects(:download).never
    @installer.expects(:unpack).never
    FileUtils.expects(:mv).never
    
    @installer.install!
  end
end