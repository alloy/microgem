##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Specification" do
  def setup
    @gem_spec = Gem::Micro.source_index.gem_specs('rake').last
  end
  
  it "should return its dependencies" do
    gem_spec = Gem::Micro.source_index.gem_specs('rails').last
    
    expected_version_requirements = [[]]
    expected_dep_names = %w{
      rake
      activesupport
      activerecord
      actionpack
      actionmailer
      activeresource
    }
    
    gem_spec.dependencies.map { |dep| dep.name }.should == expected_dep_names
  end
  
  it "should return its gem dirname" do
    @gem_spec.gem_dirname.should == 'rake-0.8.1'
  end
  
  it "should return its gem filename" do
    @gem_spec.gem_filename.should == 'rake-0.8.1.gem'
  end
  
  it "should install itself" do
    installer = Gem::Micro::Installer.new(@gem_spec)
    Gem::Micro::Installer.expects(:new).with(@gem_spec).returns(installer)
    installer.expects(:install!)
    
    @gem_spec.install!
  end
end

describe "Gem::Specification, when generating a Ruby `.gemspec' file" do
  def setup
    @gem_spec = Gem::Specification.new
  end
  
  it "should return a properly formatted Time" do
    time = Time.now
    @gem_spec.format(time).should == time.strftime("%Y-%m-%d")
  end
  
  it "should return a properly formatted Gem::Version" do
    version = Gem::Version[:version => '0.8.1']
    @gem_spec.format(version).should == version.to_s
  end
  
  it "should return a properly formatted Gem::Requirement" do
    requirement = Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]]
    @gem_spec.format(requirement).should == requirement.to_s
  end
  
  it "should return an array of key-value pairs sorted by key" do
    vars = [
      ['authors', ['Eloy Duran', 'Manfred Stienstra']],
      ['email', 'eloy@fngtps.com']
    ]
    
    # assign variables
    vars.each { |k,v| set_ivar(k, v) }
    
    # reverse to test sorting
    reversed_ivars = vars.reverse.map { |k,_| "@#{k}" }
    @gem_spec.stubs(:instance_variables).returns(reversed_ivars)
    
    @gem_spec.gem_spec_variables.should == vars
  end
  
  it "should not include special values in the gem_spec_variables" do
    set_ivar('name', 'rake')
    set_ivar('mocha', 'dev var')
    set_ivar('version', '0.8.1')
    set_ivar('dependencies', [])
    set_ivar('specification_version', '2')
    set_ivar('required_rubygems_version', '0')
    keys = @gem_spec.gem_spec_variables.map { |k,_| k }
    
    keys.should.not.include 'name'
    keys.should.not.include 'mocha'
    keys.should.not.include 'version'
    keys.should.not.include 'dependencies'
    keys.should.not.include 'specification_version'
    keys.should.not.include 'required_rubygems_version'
  end
  
  it "should generate the proper Ruby code for `specification_version'" do
    set_ivar('specification_version', 2)
    expected = 's.specification_version = 2 if s.respond_to? :specification_version='
    @gem_spec.to_ruby.should.include expected
  end
  
  it "should generate the proper Ruby code for `required_rubygems_version'" do
    set_ivar('required_rubygems_version', Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]])
    expected = 's.required_rubygems_version = Gem::Requirement.new(">= 0.8.1") if s.respond_to? :required_rubygems_version='
    @gem_spec.to_ruby.should.include expected
  end
  
  it "should return a representation of itself in ruby which is accepted by RubyGems and equals an existing gem spec created by RubyGems" do
    begin
      @gem_spec = Gem::Micro.source_index.gem_specs('rake').last
      
      spec_file = File.join(TMP_PATH, 'rake-0.8.1.gemspec.rb')
      File.open(spec_file, 'w') do |f|
        f << %{
          require 'rubygems'
          
          spec = #{@gem_spec.to_ruby}
          
          # If the dynamically created one equals the fixture we quit without error
          exit 1 unless spec == eval(File.read("#{fixture('rake-0.8.1.gemspec')}"))
        }
      end
      
      assert system("ruby '#{spec_file}'")
      
    ensure
      File.unlink(spec_file) rescue nil
    end
  end
  
  private
  
  def set_ivar(name, value)
    @gem_spec.instance_variable_set("@#{name}", value)
  end
end