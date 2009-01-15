module Gem
  module Micro
    class Installer
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns the url for the gem.
      def url
        "http://gems.rubyforge.org/gems/#{@gem_spec.gem_filename}"
      end
      
      # Downloads the gem into the +download_dir+.
      def download_to(download_dir)
        system "/usr/bin/curl -o '#{ File.join(download_dir, @gem_spec.gem_filename) }' #{url}"
      end
    end
  end
end