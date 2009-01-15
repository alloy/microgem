module Gem
  class Requirement < MiniGems::YAMLable
    attr_reader :requirements
    
    def ==(other)
      @requirements == other.requirements
    end
    
    # Returns the version that's required at minimum.
    #
    # TODO: Haven't actually encountered the case where there are multiple
    # required version yet, so that's not implemented.
    def version
      @requirements.first.last
    end
  end
end