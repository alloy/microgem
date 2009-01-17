module Gem
  class Specification < Micro::YAMLable
    attr_reader :name, :version, :dependencies
    
    # Returns the Specification's dirname:
    #
    #   rake.gem_dirname # => "rake-0.8.1"
    def gem_dirname
      "#{name}-#{version}"
    end
    
    # Returns the Specification's filename:
    #
    #   rake.gem_filename # => "rake-0.8.1.gem"
    def gem_filename
      "#{gem_dirname}.gem"
    end
  end
end