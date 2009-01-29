module Gem
  class Specification < Micro::YAMLable
    attr_reader :name, :version, :dependencies, :executables
    
    # The Gem::Micro::Source from which this Specification originates.
    attr_accessor :source
    
    # Returns the Specification's dirname:
    #
    #   rake.gem_dirname # => "rake-0.8.1"
    def gem_dirname
      "#{name}-#{version}"
    end
    alias_method :to_s, :gem_dirname
    
    # Returns the Specification's filename:
    #
    #   rake.gem_filename # => "rake-0.8.1.gem"
    def gem_filename
      "#{gem_dirname}.gem"
    end
    
    # Installs the gem for this Specification.
    def install!
      Micro::Installer.new(self).install!
    end
    
    def inspect
      "#<Gem::Specification:#{object_id} name=\"#{name}\" version=\"#{version}\">"
    end
    
    # Returns a Ruby syntax representation of the Specification which is used
    # to generate the gemspec files that RubyGems uses to check for gems.
    def to_ruby
      Micro::SpecificationEmitter.new(self).to_ruby
    end
    
    # TODO: For marshal, need to actually fix this, copied array elements code from RubyGems, cleanup
    def self._load(val)
      array = Marshal.load(val)
      spec = new
      
      spec.instance_variable_set :@rubygems_version,          array[0]
      # spec version
      spec.instance_variable_set :@name,                      array[2]
      spec.instance_variable_set :@version,                   array[3]
      spec.instance_variable_set :@date,                      array[4]
      spec.instance_variable_set :@summary,                   array[5]
      spec.instance_variable_set :@required_ruby_version,     array[6]
      spec.instance_variable_set :@required_rubygems_version, array[7]
      spec.instance_variable_set :@original_platform,         array[8]
      spec.instance_variable_set :@dependencies,              array[9]
      spec.instance_variable_set :@rubyforge_project,         array[10]
      spec.instance_variable_set :@email,                     array[11]
      spec.instance_variable_set :@authors,                   array[12]
      spec.instance_variable_set :@description,               array[13]
      spec.instance_variable_set :@homepage,                  array[14]
      spec.instance_variable_set :@has_rdoc,                  array[15]
      spec.instance_variable_set :@new_platform,              array[16]
      spec.instance_variable_set :@platform,                  array[16].to_s
      
      spec
    end
  end
end