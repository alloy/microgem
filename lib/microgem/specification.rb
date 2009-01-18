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
    
    # Returns a Ruby syntax representation of the Specification which is used
    # to generate the gemspec files that RubyGems uses to check for gems.
    def to_ruby
      Micro::SpecificationEmitter.new(self).to_ruby
    end
  end
end