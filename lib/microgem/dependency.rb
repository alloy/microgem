module Gem
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
    
    # Returns the Gem::Specification instance for this dependency.
    def gem_spec
      SourceIndex.instance.gem_specs(name).find do |gem_spec|
        gem_spec.version == @version_requirements.version
      end
    end
  end
end