module Gem
  class Version < Micro::YAMLable
    class Requirement < Micro::YAMLable
    end
    
    # Returns a Gem::Version from a string:
    #
    #   Gem::Version.from_gem_dirname('rake-0.8.1').version # => "0.8.1"
    def self.from_gem_dirname(dirname)
      if dirname =~ /-([\d\.]+)$/
        self[:version => $1]
      end
    end
    
    attr_reader :version
    alias_method :to_s, :version
    
    include Comparable
    
    def <=>(other)
      version <=> other.version
    end
    
    def any?
      version == 0 || version == '0'
    end
    
    # TODO: really test this method, added for utils test
    def marshal_load(version)
      @version = version.first
    end
  end
end