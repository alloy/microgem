##!/usr/bin/env macruby

require File.expand_path('../test_helper', __FILE__)

describe "Gem::Micro::SpecificationEmitter" do
  def setup
    @gem_spec = Gem::Specification.new
    set_ivar('dependencies', [])
    
    @emitter = Gem::Micro::SpecificationEmitter.new(@gem_spec)
  end
  
  it "should return a properly formatted Time" do
    time = Time.now
    @emitter.format(time).should == time.strftime("%Y-%m-%d")
  end
  
  it "should return a properly formatted Date" do
    date = Date.today
    @emitter.format(date).should == date.to_s
  end
  
  it "should return a properly formatted Gem::Version" do
    version = Gem::Version[:version => '0.8.1']
    @emitter.format(version).should == version.to_s
  end
  
  it "should return a properly formatted Gem::Requirement" do
    requirement = Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]]
    @emitter.format(requirement).should == requirement.to_s
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
    
    @emitter.gem_spec_variables.should == vars
  end
  
  it "should not include special values in the gem_spec_variables" do
    set_ivar('name', 'rake')
    set_ivar('mocha', 'dev var')
    set_ivar('source', 'gems.rubyforge.org')
    set_ivar('version', '0.8.1')
    set_ivar('dependencies', [])
    set_ivar('new_platform', 'ruby')
    set_ivar('specification_version', '2')
    set_ivar('required_rubygems_version', '0')
    keys = @emitter.gem_spec_variables.map { |k,_| k }
    
    keys.should.not.include 'name'
    keys.should.not.include 'mocha'
    keys.should.not.include 'source'
    keys.should.not.include 'version'
    keys.should.not.include 'dependencies'
    keys.should.not.include 'new_platform'
    keys.should.not.include 'specification_version'
    keys.should.not.include 'required_rubygems_version'
  end
  
  it "should generate the proper Ruby code for `specification_version'" do
    set_ivar('specification_version', 2)
    expected = 's.specification_version = 2 if s.respond_to? :specification_version='
    @emitter.to_ruby.should.include expected
  end
  
  it "should generate the proper Ruby code for `required_rubygems_version'" do
    set_ivar('required_rubygems_version', Gem::Requirement[:requirements => [['>=', Gem::Version[:version => '0.8.1']]]])
    expected = 's.required_rubygems_version = Gem::Requirement.new(">= 0.8.1") if s.respond_to? :required_rubygems_version='
    @emitter.to_ruby.should.include expected
  end
  
  it "should generate the proper Ruby code for `required_rubygems_version' if it's nil" do
    set_ivar('required_rubygems_version', nil)
    expected = 's.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version='
    @emitter.to_ruby.should.include expected
  end
  
  it "should generate the proper Ruby code for a Gem::Dependency" do
    @gem_spec = gem_spec_fixture('rails', '2.1.1')
    @emitter = Gem::Micro::SpecificationEmitter.new(@gem_spec)
    
    rake_dependency = 's.add_dependency("rake", [">= 0.8.1"])'
    @emitter.to_ruby.should.include rake_dependency
  end
  
  # For these we need to download the specific gems their metadata yaml files
  [['rake', '0.8.1'], ['rails', '2.1.1']].each do |gem_name, gem_version|
    xit "should return a representation of the Ruby #{gem_name} gemspec, which is accepted by RubyGems" do
      begin
        gemspec_file = "#{gem_name}-#{gem_version}.gemspec"
        
        @gem_spec = YAML.load(File.read(fixture("#{gemspec_file}.full")))
        @emitter = Gem::Micro::SpecificationEmitter.new(@gem_spec)
        
        @gem_spec.instance_variable_set(:@rubygems_version, Gem::Version[:version => '1.3.1'])
        spec_file = File.join(TMP_PATH, "#{gemspec_file}.rb")
        
        File.open(spec_file, 'w') do |f|
          f << %{
            require 'rubygems'
            
            spec = #{@emitter.to_ruby}
            
            # If the dynamically created one equals the fixture we quit without error
            exit 1 unless spec == eval(File.read("#{fixture(gemspec_file)}"))
          }
        end
        
        # debugging
        unless system("ruby '#{spec_file}'")
          output_file = File.join(TMP_PATH, gemspec_file)
          File.open(output_file, 'w') { |f| f << @emitter.to_ruby }
          puts `diff -y '#{fixture(gemspec_file)}' '#{output_file}'`
        end
        
        assert system("ruby '#{spec_file}'")
        
      ensure
        File.unlink(spec_file) rescue nil
      end
    end
  end
  
  private
  
  def set_ivar(name, value)
    @gem_spec.instance_variable_set("@#{name}", value)
  end
end