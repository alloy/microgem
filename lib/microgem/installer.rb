module Gem
  module Micro
    class Installer
      class DownloadError < StandardError; end
      
      include Utils
      
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns the download url for the gem.
      #
      #   installer.url # => "http://gems.rubyforge.org/gems/rake-0.8.1.gem"
      def url
        File.join(Config[:gem_source_url], @gem_spec.gem_filename)
      end
      
      # Returns the full path to the temporary gem directory.
      #
      #   installer.work_dir # => "/path/to/tmp/microgem/rake-0.8.1"
      def work_dir
        File.join(tmpdir, @gem_spec.gem_dirname)
      end
      
      # Returns the full path to the gem in the temporary directory.
      #
      #   installer.work_path # => "/path/to/tmp/microgem/rake-0.8.1.gem"
      def work_path
        File.join(tmpdir, @gem_spec.gem_filename)
      end
      
      # Returns the path to where the gem should be installed.
      #
      #   installer.install_path # => "/usr/local/lib/ruby/gems/1.8/gems/rake-0.8.1"
      def install_path
        File.join(Config[:install_dir], @gem_spec.gem_dirname)
      end
      
      # Downloads the gem to work_path. Raises a
      # Gem::Micro::Installer::DownloadError if downloading fails.
      def download
        log(:debug, "Downloading #{url} to: #{work_path}")
        unless system("/usr/bin/curl --silent --location --output '#{work_path}' #{url}")
          raise DownloadError, "Failed to download: #{url}"
        end
      end
      
      def install!
        log(:info, "Installing: #{@gem_spec}")
        
        @gem_spec.dependencies.each do |dep|
          dep.gem_spec.install! unless dep.meets_requirements?
        end
        
        download
      end
    end
  end
end