module Gem
  class Dependency < MiniGems::YAMLable
    attr_reader :name, :version, :version_requirements
  end
end