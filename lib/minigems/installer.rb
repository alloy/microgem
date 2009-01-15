module Gem
  module MiniGems
    class Installer
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns the url for the gem.
      def url
        "http://gems.rubyforge.org/gems/#{@gem_spec.gem_filename}"
      end
    end
  end
end