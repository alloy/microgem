module Gem
  class Requirement < MiniGems::YAMLable
    attr_reader :requirements
    
    def ==(other)
      @requirements == other.requirements
    end
  end
end