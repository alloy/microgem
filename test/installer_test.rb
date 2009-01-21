##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Installer, in general" do
  include Gem::Micro::Utils
  
  def setup
    @gem_spec = Marshal.load(File.read(fixture('rake-0.8.1.gemspec.marshal')))
    @source = Gem::Micro::Source.new('gems.github.com', tmpdir)
    @gem_spec.source = @source
    @installer = Gem::Micro::Installer.new(@gem_spec)
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return the url to download the gem from" do
    @installer.url.should == "http://gems.github.com/gems/rake-0.8.1.gem"
  end
  
  it "should return the path to the install path" do
    @installer.install_path.should ==
      File.join(Gem::Micro::Config.gems_path, 'rake-0.8.1')
  end
  
  it "should return the path to the gem in the temporary work directory" do
    @installer.work_dir.should ==
      File.join(tmpdir, 'rake-0.8.1')
  end
  
  it "should return the path to the gems data directory in the temporary directory" do
    @installer.data_dir.should ==
      File.join(@installer.work_dir, 'data')
  end
  
  it "should return the path to the gems data archive in the temporary directory" do
    @installer.data_file.should ==
      File.join(@installer.work_dir, 'data.tar.gz')
  end
  
  it "should download the gem to the work directory" do
    Gem::Micro::Downloader.expects(:get).with(@installer.url, @installer.gem_file)
    @installer.download
  end
  
  it "should unpack the gem using tar" do
    @installer.stubs(:gem_file).returns(fixture('rake-0.8.1.gem'))
    @installer.unpack
    File.should.exist File.join(@installer.work_dir, 'data', 'README')
  end
  
  it "should return the path to the Ruby `.gemspec' file" do
    @installer.ruby_gemspec_file.should ==
      File.join(Gem::Micro::Config.specifications_path, 'rake-0.8.1.gemspec')
  end
  
  it "should create a `.gemspec' file so RubyGems can find the gem" do
    FileUtils.mkdir_p(File.dirname(@installer.ruby_gemspec_file))
    @installer.create_ruby_gemspec!
    
    File.read(@installer.ruby_gemspec_file).should == @gem_spec.to_ruby
  end
  
  it "should return the path to the gem cache directory" do
    @installer.gem_cache_file.should ==
      File.join(Gem::Micro::Config.cache_path, @gem_spec.gem_filename)
  end
  
  # FIXME: The marshalled gemspecs don't contain all data, we need to get this
  # from the metadata.tar.gz archive in the gem.
  xit "should create bin wrappers for each executable" do
    emitter = Gem::Micro::BinWrapperEmitter.new('rake', 'rake')
    Gem::Micro::BinWrapperEmitter.expects(:new).with('rake', 'rake').returns(emitter)
    emitter.expects(:create_bin_wrapper!)
    
    @installer.create_bin_wrappers!
  end
end

describe "Gem::Micro::Installer.install" do
  def setup
    @gem_spec = Marshal.load(File.read(fixture('rake-0.8.1.gemspec.marshal')))
    @installer = Gem::Micro::Installer.new(@gem_spec)
    @installer.stubs(:download)
    @installer.stubs(:unpack)
    @installer.stubs(:create_ruby_gemspec!)
    @installer.stubs(:create_bin_wrappers!)
    @installer.stubs(:replace)
  end
  
  xit "should install its dependencies that are not installed yet" do
    #Gem::Micro::Source.expects(:gem_spec)
    
    @gem_spec = Marshal.load(File.read(fixture('rails-2.1.1.gemspec.marshal')))
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
    @installer.expects(:replace).with(@installer.data_dir, @installer.install_path)
    @installer.install!
  end
  
  it "should move the gem file to gem_cache_file" do
    @installer.expects(:replace).with(@installer.gem_file, @installer.gem_cache_file)
    @installer.install!
  end
  
  it "should create bin wrappers" do
    @installer.expects(:create_bin_wrappers!)
    @installer.install!
  end
  
  it "should create a `.gemspec' file" do
    @installer.expects(:create_ruby_gemspec!)
    @installer.install!
  end
  
  it "should skip the actual installation of the gem _if_ after installing the dependencies it exists" do
    File.expects(:exist?).with(@installer.install_path).returns(true)
    @installer.expects(:download).never
    @installer.expects(:unpack).never
    @installer.expects(:replace).never
    @installer.expects(:create_bin_wrappers!).never
    @installer.expects(:create_ruby_gemspec!).never
    
    @installer.install!
  end
  
  it "should _not_ skip the actual installation of the gem _if_ after installing the dependencies it exists" do
    File.stubs(:exist?).returns(true)
    
    @installer.expects(:download).times(1)
    @installer.expects(:unpack).times(1)
    @installer.expects(:replace).times(2)
    @installer.expects(:create_bin_wrappers!).times(1)
    @installer.expects(:create_ruby_gemspec!).times(1)
    
    @installer.install!(true)
  end
end