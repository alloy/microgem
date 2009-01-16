module Gem
  module Micro
    class Installer
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns the url for the gem.
      def url
        File.join(Config[:gem_source_url], @gem_spec.gem_filename)
      end
      
      # Returns the location on disk to where the gem should be downloaded.
      def install_location
        File.join(Config[:install_dir], @gem_spec.gem_filename)
      end
      
      # Downloads the gem into Gem::Micro::Config[:install_dir]
      def download
        Micro.log(:debug, "Downloading #{url} to: #{install_location}")
        system "/usr/bin/curl -o '#{install_location}' #{url}"
      end
    end
  end
end