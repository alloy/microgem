module Gem
  module Micro
    class GemSpecMissingError < StandardError; end
  end
  
  class Dependency < Micro::YAMLable
    attr_reader :name, :version, :version_requirements
    
    # Returns whether or not any of the installed gems matches the requirements.
    #
    # For now we just compare against the last one which should be the highest.
    def meets_requirements?
      if dirname = Micro.installed_gem_dirnames(name).last
        Gem::Version.from_gem_dirname(dirname) >= @version_requirements.version
      end
    end
    
    # Returns the Gem::Specification instance for this dependency. If the
    # required version is `0' then the latest version is used.
    def gem_spec
      if @gem_spec.nil?
        gem_specs = Micro.source_index.gem_specs(name)
        
        @gem_spec = if @version_requirements.version.any?
          gem_specs.last
        else
          gem_specs.find do |gem_spec|
            gem_spec.version == @version_requirements.version
          end
        end
        
        unless @gem_spec
          raise Micro::GemSpecMissingError, "Unable to locate Gem::Specification for Gem::Dependency `#{self}'"
        end
      end
      
      @gem_spec
    end
    
    # Returns a ‘pretty’ string representation of the Dependency instance:
    #
    #   dependency.to_s # => "rake >= 0.8.1"
    def to_s
      "#{name} #{@version_requirements}"
    end
  end
end