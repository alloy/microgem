module Gem
  class Specification < Micro::YAMLable
    attr_reader :name, :version, :dependencies
    
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
    
    SPECIAL_INSTANCE_VARIABLES = [
      'name',
      'mocha',
      'version',
      'dependencies',
      'specification_version',
      'required_rubygems_version'
    ]
    
    # Returns a list of all instance variables sorted by their keys.
    #
    #   gem_spec.gem_spec_variables # => [["author", ["Eloy Duran"]], ["version", "0.5.2"] …]
    def gem_spec_variables
      instance_variables.sort.map do |ivar|
        key = ivar[1..-1]
        next if SPECIAL_INSTANCE_VARIABLES.include?(key)
        value = format(instance_variable_get(ivar))
        [key, value]
      end.compact
    end
    
    # Properly formats objects so they can be written to a Ruby `.gemspec' file.
    def format(obj)
      case obj
      when Time
        obj.strftime("%Y-%m-%d")
      when Gem::Version, Gem::Requirement
        obj.to_s
      else
        obj
      end
    end
    
    # Returns a Ruby syntax representation of the Specification which is used
    # to generate the gemspec files that RubyGems uses to check for gems.
    #
    # TODO 1: Add dependencies.
    # 
    # TODO 2: We are still missing the following values, but it might not be a
    # real problem. So we need to figure out if they are important to RubyGems
    # and if so where it gets these values from.
    #
    # * files
    # * extra_rdoc_files
    # * rdoc_options
    # * test_files
    def to_ruby
%{Gem::Specification.new do |s|
  s.name = "#{name}"
  s.version = "#{version}"

  s.specification_version = #{ @specification_version || 2 } if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new("#{@required_rubygems_version}") if s.respond_to? :required_rubygems_version=

#{gem_spec_variables.map { |k,v| "  s.#{k} = #{v.inspect}" }.join("\n") }
end}
    end
  end
end