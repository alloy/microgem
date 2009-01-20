##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::BareSpecification" do
  include Gem::Micro::Utils
  
  def setup
    @source = Gem::Micro::Source.new('gems.rubyforge.org', @dir)
    @spec = Gem::Micro::BareSpecification.new(@source, 'rake', Gem::Version[:version => '0.8.1'])
  end
  
  def teardown
    remove_microgem_tmpdir!
  end
  
  it "should return the url to a gemspec" do
    @spec.gem_spec_url.should ==
      "http://gems.rubyforge.org/quick/Marshal.4.8/rake-0.8.1.gemspec.rz"
  end
  
  it "should return the path to the work gemspec file" do
    @spec.gem_spec_work_file.should ==
      File.join(tmpdir, 'rake-0.8.1.gemspec')
  end
  
  it "should return the path to the work archive of the gemspec file" do
    @spec.gem_spec_work_archive_file.should ==
      File.join(tmpdir, 'rake-0.8.1.gemspec.rz')
  end
  
  it "should return its gem spec and know from which source it came" do
    Gem::Micro::Downloader.expects(:get).with(@spec.gem_spec_url, @spec.gem_spec_work_archive_file)
    FileUtils.cp(fixture('rake-0.8.1.gemspec.rz'), tmpdir)
    
    gem_spec = @spec.gem_spec
    gem_spec.should.be.instance_of Gem::Specification
    gem_spec.name.should == 'rake'
    gem_spec.version.should == Gem::Version[:version => '0.8.1']
    gem_spec.source.should == @source
  end
  
end