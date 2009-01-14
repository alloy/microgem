module Gem
  class Specification < MiniGems::YAMLable
    attr_reader :name, :version
  end
end