##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::Installer, in general" do
  def setup
    @gem_spec = Gem::SourceIndex.instance.gem_specs('rake').last
    @installer = Gem::Micro::Installer.new(@gem_spec)
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
  
  it "should download the gem using curl to the work directory" do
    @installer.expects(:system).
      with("/usr/bin/curl -o '#{@installer.work_path}' #{@installer.url}")
    
    @installer.download
  end
end

describe "Gem::Micro::Installer.install" do
  def setup
    @gem_spec = Gem::SourceIndex.instance.gem_specs('rake').last
    @installer = Gem::Micro::Installer.new(@gem_spec)
    @installer.stubs(:download)
  end
  
  it "should download the gem" do
    @installer.expects(:download)
    @installer.install!
  end
  
  it "should install its dependencies that are not installed yet" do
    @gem_spec = Gem::SourceIndex.instance.gem_specs('rails').last
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
end