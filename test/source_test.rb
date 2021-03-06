##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Source, class methods" do
  include Gem::Micro::Utils
  
  def setup
    @sources = Gem::Micro::Source.sources
  end
  
  def teardown
    Gem::Micro::Source.instance_variable_set(:@sources, nil)
  end
  
  it "should load the sources specified on config.sources in config.gem_home" do
    Gem::Micro::Source.instance_variable_set(:@sources, nil)
    
    hosts = %w{ gems.superalloy.nl gems.fngtps.com }
    config.stubs(:sources).returns(hosts)
    sources = Gem::Micro::Source.sources
    
    sources.map { |s| s.host }.should == hosts
    sources.map { |s| s.index_file }.should ==
      [File.join(config.gem_home, hosts.first), File.join(config.gem_home, hosts.last)]
  end
  
  it "should return matching gem specs from any source and mark them to know from which source they came" do
    rake = ['rake', Gem::Version[:version => '0.8.1']]
    
    rubyforge_bare_spec = mock('Rubyforge')
    Gem::Micro::BareSpecification.expects(:new).with(@sources.first, *rake).returns(rubyforge_bare_spec)
    rubyforge_bare_spec.expects(:gem_spec).returns('rake from rubyforge')
    
    Gem::Micro::Source.gem_spec(*rake).should == 'rake from rubyforge'
  end
  
  it "should tell the sources to update" do
    @sources.first.expects(:update!)
    @sources.last.expects(:update!)
    Gem::Micro::Source.update!
  end
end

describe "Gem::Micro::Source, in general" do
  def setup
    @dir = Gem::Micro::Utils.tmpdir
    @source = Gem::Micro::Source.new('gems.rubyforge.org', @dir)
  end
  
  it "should return the path to the index file" do
    @source.index_file.should == File.join(@dir, 'gems.rubyforge.org')
  end
  
  it "should return the url from where to get the marshalled gem list" do
    @source.specs_url.should == 'http://gems.rubyforge.org/specs.4.8.gz'
  end
  
  it "should return the path to the work archive file" do
    @source.work_archive_file.should == File.join(@dir, 'specs.4.8.gz')
  end
  
  it "should return the path to the work index file" do
    @source.work_index_file.should == File.join(@dir, 'specs.4.8')
  end
end

describe "Gem::Micro::Source, for a non existing index" do
  include Gem::Micro::Utils
  
  def setup
    @dir = File.join(tmpdir, 'specs')
    ensure_dir(@dir)
    @source = Gem::Micro::Source.new('gems.rubyforge.org', @dir)
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return that it doesn't exist" do
    @source.should.not.exist
  end
  
  it "should download and unpack the index to index_file" do
    Gem::Micro::Downloader.expects(:get).with(@source.specs_url, @source.work_archive_file)
    FileUtils.cp(fixture('specs.4.8.gz'), tmpdir) # fake the download to the tmpdir
    
    @source.update!
    
    File.should.exist @source.index_file
    Marshal.load(File.read(@source.index_file)).should.be.instance_of Array
  end
  
  it "should update! if the #specs are accessed but the index_file doesn't exist yet" do
    # make sure the fixture is in place
    Gem::Micro::Downloader.stubs(:get)
    FileUtils.cp(fixture('specs.4.8.gz'), tmpdir)
    @source.update!
    
    @source.stubs(:exist?).returns(false)
    @source.expects(:update!)
    @source.specs
  end
end

describe "Gem::Micro::Source, for an existing index" do
  include Gem::Micro::Utils
  
  def setup
    @dir = File.join(tmpdir, 'specs')
    ensure_dir(@dir)
    @source = Gem::Micro::Source.new('gems.rubyforge.org', @dir)
    
    # create the index
    Gem::Micro::Downloader.stubs(:get)
    FileUtils.cp(fixture('specs.4.8.gz'), tmpdir)
    @source.update!
    
    @rake = ['rake', Gem::Version[:version => '0.8.3']]
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return that it exists" do
    @source.should.exist
  end
  
  it "should return a spec matching the given name and version" do
    rake_0_8_1 = @source.spec('rake', Gem::Version[:version => '0.8.1'])
    rake_0_8_1[1].to_s.should == '0.8.1'
  end
  
  it "should return the last spec matching the given name and a version of any?" do
    rake_0_8_3 = @source.spec('rake', Gem::Version[:version => '0'])
    rake_0_8_3[1].to_s.should == '0.8.3'
  end
  
  it "should return a gem spec matching the given name" do
    spec = mock('BareSpecification')
    Gem::Micro::BareSpecification.expects(:new).with(@source, *@rake).returns(spec)
    spec.expects(:gem_spec).returns("The Gem::Specification")
    
    @source.gem_spec(*@rake).should == "The Gem::Specification"
  end
  
  it "should use the latest version if the specified version is any?" do
    Gem::Micro::BareSpecification.expects(:new).with(@source, *@rake).returns(stub_everything)
    @source.gem_spec('rake', Gem::Version[:version => '0'])
  end
end