module Gem
  class Version < MiniGems::YAMLable
    attr_reader :version
    alias_method :to_s, :version
    
    def ==(other)
      version == other.version
    end
  end
end