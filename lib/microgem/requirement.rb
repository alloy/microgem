module Gem
  class Requirement < Micro::YAMLable
    attr_reader :requirements
    
    def ==(other)
      @requirements == other.requirements
    end
    
    def operator
      @requirements.first.first
    end
    
    # Returns the version that's required at minimum.
    #
    # TODO: Haven't actually encountered the case where there are multiple
    # required version yet, so that's not implemented.
    def version
      @requirements.first.last
    end
    
    def to_s
      "#{operator} #{version}"
    end
  end
end