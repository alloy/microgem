module Gem
  module Micro
    class SpecificationEmitter
      SPECIAL_INSTANCE_VARIABLES = [
        'name',
        'mocha',
        'version',
        'dependencies',
        'specification_version',
        'required_rubygems_version'
      ]
      
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns a list of all instance variables sorted by their keys.
      #
      #   gem_spec.gem_spec_variables # => [["author", ["Eloy Duran"]], ["version", "0.5.2"] …]
      def gem_spec_variables
        @gem_spec.instance_variables.sort.map do |ivar|
          key = ivar[1..-1]
          next if SPECIAL_INSTANCE_VARIABLES.include?(key)
          value = format(ivar_get(key))
          [key, value]
        end.compact
      end
      
      # Properly formats objects so they can be written to a Ruby `.gemspec' file.
      def format(obj)
        case obj
        when Time
          obj.strftime("%Y-%m-%d")
        when Date, Gem::Version, Gem::Requirement
          obj.to_s
        else
          obj
        end
      end
      
      # Returns a Ruby syntax representation of the Specification which is used
      # to generate the gemspec files that RubyGems uses to check for gems.
      # 
      # TODO: We are still missing the following values, but it might not be a
      # real problem. So we need to figure out if they are important to RubyGems
      # and if so where it gets these values from.
      #
      # * files
      # * extra_rdoc_files
      # * rdoc_options
      # * test_files
      def to_ruby
%{Gem::Specification.new do |s|
  s.name = "#{@gem_spec.name}"
  s.version = "#{@gem_spec.version}"

  s.specification_version = #{ ivar_get(:specification_version) || 2 } if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new("#{ivar_get(:required_rubygems_version) || '>= 0'}") if s.respond_to? :required_rubygems_version=

#{gem_spec_variables.map { |k,v| "  s.#{k} = #{v.inspect}" }.join("\n") }

#{@gem_spec.dependencies.map { |dep| "  s.add_dependency(\"#{dep.name}\", [\"#{dep.version_requirements.to_s}\"])" }.join("\n") }
end}
      end
      
      private
      
      def ivar_get(name)
        @gem_spec.instance_variable_get("@#{name}")
      end
    end
  end
end