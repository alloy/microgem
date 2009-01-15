module Gem
  class Specification < Micro::YAMLable
    attr_reader :name, :version, :dependencies
    
    def gem_filename
      "#{name}-#{version}.gem"
    end
  end
end