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

describe "Gem::Micro::Source, for a non existing index on disk" do
  
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
  
  it "should return the path to the work index file" do
    @source.work_index_file.should == File.join(@dir, 'specs.4.8.gz')
  end
  
  it "should return that it doesn't exist" do
    @source.should.not.exist
  end
  
  it "should download and unpack the index to the index_path" do
    Gem::Micro::Downloader.expects(:get).with(@source.specs_url, @source.work_index_file)
    @source.expects(:untar).with(@source.work_index_file, @source.index_file, true)
    @source.get_index!
  end
end
