module Gem
  class Requirement < Micro::YAMLable
    attr_reader :requirements
    
    def ==(other)
      @requirements == other.requirements
    end
    
    # Returns the operator for this the highest version.
    #
    #   requirement.operator # => ">="
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
    
    # Returns a ‘pretty’ string representation of the Requirement instance:
    #
    #   requirement.to_s # => ">= 0.8.1"
    def to_s
      "#{operator} #{version}"
    end
  end
end