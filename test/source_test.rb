##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

xdescribe "Gem::Micro::Source, class methods" do
  include Gem::Micro
  
  it "should add sources" do
    Source.add_source('gems.rubyforge.org')
    Source.add_source('gems.github.com')
    
    Source.sources.should == [Source.new('gems.rubyforge.org'), Source.new('gems.github.com')]
  end
  
  it "should return gem specs from all sources and mark them to know form which source they came" do
    # stub old version from rubyforge, new version from github
    rubyforge_gem_spec, github_gem_spec = Source.gem_specs('rake')
    rubyforge_gem_spec.source.should == 'gems.rubyforge.org'
    github_gem_spec.source.should == 'gems.github.com'
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
    Gem::Micro::Downloader.expects(:get).with(@source.specs_url, @source.work_index_file)
    FileUtils.cp(fixture('specs.4.8.gz'), tmpdir) # fake the download to the tmpdir
    
    @source.get_index!
    
    File.should.exist @source.index_file
    Marshal.load(File.read(@source.index_file)).should.be.instance_of Array
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
    @source.get_index!
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
  
  it "should return the url to a gemspec" do
    @source.gem_spec_url('rake', Gem::Version[:version => '0.8.1']).should ==
      "http://gems.rubyforge.org/quick/Marshal.4.8/rake-0.8.1.gemspec.rz"
  end
  
  xit "should return a gem spec matching the given name" do
    gem_spec = @source.gem_spec('rake', Gem::Version[:version => '0.8.1'])
    gem_spec.should.be.instance_of Gem::Specification
  end
end