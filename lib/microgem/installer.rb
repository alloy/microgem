module Gem
  module Micro
    class Installer
      class DownloadError < StandardError; end
      class UnpackError < StandardError; end
      
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
      #   installer.gem_file # => "/path/to/tmp/microgem/rake-0.8.1.gem"
      def gem_file
        File.join(tmpdir, @gem_spec.gem_filename)
      end
      
      # Returns the full path to the gems data directory in the temporary
      # directory.
      #
      #   installer.data_dir # => "/path/to/tmp/microgem/rake-0.8.1/data"
      def data_dir
        File.join(work_dir, 'data')
      end
      
      # Returns the full path to the gems data archive in the temporary
      # directory.
      #
      #   installer.data_file # => "/path/to/tmp/microgem/rake-0.8.1/data.tar.gz"
      def data_file
        "#{data_dir}.tar.gz"
      end
      
      # Returns the path to where the gem should be installed.
      #
      #   installer.install_path # => "/usr/local/lib/ruby/gems/1.8/gems/rake-0.8.1"
      def install_path
        File.join(Config[:install_dir], @gem_spec.gem_dirname)
      end
      
      # Downloads the gem to gem_file.
      #
      # Raises a Gem::Micro::Installer::DownloadError if downloading fails.
      def download
        log(:debug, "Downloading `#{url}' to `#{gem_file}'")
        curl(url, gem_file)
      end
      
      # Unpacks the gem to work_dir.
      #
      # Raises a Gem::Micro::Installer::UnpackError if unpacking fails.
      def unpack
        log(:debug, "Unpacking `#{gem_file}' to `#{work_dir}'")
        
        untar(gem_file, work_dir, false)
        untar(data_file, data_dir, true)
      end
      
      # Installs all dependencies and then the gem itself.
      def install!
        install_dependencies!
        
        log(:info, "Installing: #{@gem_spec}")
        download
        unpack
        FileUtils.mv(data_dir, install_path)
      end
      
      private
      
      def install_dependencies!
        @gem_spec.dependencies.each do |dep|
          dep.gem_spec.install! unless dep.meets_requirements?
        end
      end
      
      def curl(url, to)
        unless system("/usr/bin/curl --silent --location --output '#{to}' #{url}")
          raise DownloadError, "Failed to download `#{url}'"
        end
      end
      
      def untar(file, to, gzip)
        FileUtils.mkdir(to) unless File.exist?(to)
        unless system("/usr/bin/tar --directory='#{to}' -#{ 'z' if gzip }xf '#{file}' > /dev/null 2>&1")
          raise UnpackError, "Failed to unpack `#{file}'"
        end
      end
    end
  end
end