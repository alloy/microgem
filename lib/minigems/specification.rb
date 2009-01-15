module Gem
  class Specification < MiniGems::YAMLable
    attr_reader :name, :version, :dependencies
    
    def gem_filename
      "#{name}-#{version}.gem"
    end
  end
end