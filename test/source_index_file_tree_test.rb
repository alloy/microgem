##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::SourceIndexFileTree, when creating a file tree" do
  def setup
    @root = File.join(TMP_PATH, 'microgem_source_index_create_test')
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  it "should create a source index file tree and return it" do
    index = Gem::Micro::SourceIndexFileTree.create(@root, Gem::SourceIndex.instance)
    
    File.should.exist @root
    File.should.exist File.join(@root, 'r', 'rails-2.1.0.yaml')
    File.should.exist File.join(@root, 'r', 'rails-2.1.1.yaml')
    
    index.instance_variable_get(:@nodes).length.should ==
      Gem::SourceIndex.instance.gems.length
  end
end

describe "Gem::Micro::SourceIndexFileTree, in general" do
  def setup
    @root = File.join(TMP_PATH, 'microgem_source_index_test')
    Gem::Micro::SourceIndexFileTree.create(@root, Gem::SourceIndex.instance) unless File.exist?(@root)
    
    @index = Gem::Micro::SourceIndexFileTree.new(@root)
  end
  
  it "should return a node for a given name" do
    node = @index['rake-0.8.1']
    node.should.be.instance_of Gem::Micro::SourceIndexFileTree::Node
    node.gem_spec.to_s.should == "rake-0.8.1"
  end
  
  it "should cache the nodes it loads" do
    @index['rake-0.8.1'].should.be @index['rake-0.8.1']
  end
  
  it "should add a node" do
    node = Gem::Micro::SourceIndexFileTree::Node.new(@root, 'rake-0.8.1')
    @index.add_node(node)
    @index['rake-0.8.1'].should.be node
  end
  
  it "should return nil for gems for which no gem spec exists" do
    before = @index.instance_variable_get(:@nodes).length
    @index['does-not-exist-1.2.3'].should.be nil
    @index.instance_variable_get(:@nodes).length.should.be before
  end
  
  it "should return a list of gem specs matching the given name" do
    gem_specs = @index.gem_specs('rails')
    gem_specs.length.should.be 2
    gem_specs.each { |gem_spec| gem_spec.name.should == 'rails' }
  end
  
  it "should not return gem specs matching only the first part of the name" do
    gem_specs = @index.gem_specs('test-spec')
    gem_specs.length.should.be 2
    gem_specs.each { |gem_spec| gem_spec.name.should.not == 'test-spec-mock' }
  end
  
  it "should return the matching gem specs sorted by version" do
    def @index.gems # stub #gems to return the gems in reverse order
      @gems.to_a.sort_by { |_, spec| spec.version.to_s }.reverse
    end
    
    @index.gem_specs('rails').map { |s| s.version.to_s }.should == %w{ 2.1.0 2.1.1 }
  end
end

describe "Gem::Micro::SourceIndexFileTree::Node, with a gem spec" do
  def setup
    @root = File.join(TMP_PATH, 'microgem_source_index_create_test')
    @gem_spec = Gem::SourceIndex.instance.gem_specs('rake').last
    @node = Gem::Micro::SourceIndexFileTree::Node.new(@root, @gem_spec)
  end
  
  def teardown
    FileUtils.rm_rf(@root)
  end
  
  it "should return its dirname" do
    @node.dirname.should == 'rake-0.8.1'
  end
  
  it "should create a gem spec file" do
    @node.create_gem_spec_file!
    gem_spec = YAML.load(File.read(@node.full_path))
    
    gem_spec.should.be.instance_of Gem::Specification
    gem_spec.to_s.should == "rake-0.8.1"
  end
  
  it "should return true for an existing gem spec file" do
    @node.create_gem_spec_file!
    assert @node.exist?
  end
end

describe "Gem::Micro::SourceIndexFileTree::Node, with a gem dirname" do
  def setup
    @root = File.join(TMP_PATH, 'microgem_source_index_test')
    @node = Gem::Micro::SourceIndexFileTree::Node.new(@root, 'rake-0.8.1')
  end
  
  it "should return its dirname" do
    @node.dirname.should == 'rake-0.8.1'
  end
  
  it "should load its gem spec from disk" do
    @node.gem_spec.should.be.instance_of Gem::Specification
    @node.gem_spec.to_s.should == "rake-0.8.1"
  end
end

describe "Gem::Micro::SourceIndexFileTree::Node, in general" do
  def setup
    @root = File.join(TMP_PATH, 'microgem_source_index_test')
    @node = Gem::Micro::SourceIndexFileTree::Node.new(@root, 'CapitalGem-0.8.1')
  end
  
  it "should return its dirname" do
    @node.dirname.should == 'CapitalGem-0.8.1'
  end
  
  it "should return the path to the yaml gem spec file with a downcased dirname" do
    @node.full_path.should == File.join(@root, 'c', 'CapitalGem-0.8.1.yaml')
  end
  
  it "should return false for a non existing gem spec file" do
    assert !@node.exist?
  end
end