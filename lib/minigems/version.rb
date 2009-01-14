module Gem
  class Version < MiniGems::YAMLable
    attr_reader :version
    alias_method :to_s, :version
  end
end