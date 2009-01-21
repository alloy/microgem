module Gem
  module Micro
    class Installer
      include Utils
      
      def initialize(gem_spec)
        @gem_spec = gem_spec
      end
      
      # Returns the download url for the gem.
      #
      #   installer.url # => "http://gems.rubyforge.org/gems/rake-0.8.1.gem"
      def url
        "http://#{File.join(@gem_spec.source.host, 'gems', @gem_spec.gem_filename)}"
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
      
      # Returns the full path to the gems Ruby `.gemspec' file. This file is
      # needed by RubyGems to find the gem.
      def ruby_gemspec_file
        ensure_dir Config.specifications_path
        File.join(Config.specifications_path, "#{@gem_spec.gem_dirname}.gemspec")
      end
      
      # Returns the full path to the RubyGems gem file cache directory.
      def gem_cache_file
        ensure_dir Config.cache_path
        File.join(Config.cache_path, @gem_spec.gem_filename)
      end
      
      # Returns the path to where the gem should be installed.
      #
      #   installer.install_path # => "/usr/local/lib/ruby/gems/1.8/gems/rake-0.8.1"
      def install_path
        File.join(Config.gems_path, @gem_spec.gem_dirname)
      end
      
      # Downloads the gem to gem_file.
      #
      # Raises a Gem::Micro::Downloader::DownloadError if downloading fails.
      def download
        Downloader.get(url, gem_file)
      end
      
      # Unpacks the gem to work_dir.
      #
      # Raises a Gem::Micro::Installer::UnpackError if unpacking fails.
      def unpack
        Unpacker.tar(gem_file, work_dir, false)
        Unpacker.tar(data_file, data_dir, true)
      end
      
      # Creates the Ruby `.gemspec' used by RubyGems to find a gem at
      # ruby_gemspec_file.
      def create_ruby_gemspec!
        log(:debug, "Creating gem spec file `#{ruby_gemspec_file}'")
        File.open(ruby_gemspec_file, 'w') { |f| f << @gem_spec.to_ruby }
      end
      
      # Creates the executables for this gem in the Ruby bin dir.
      def create_bin_wrappers!
        @gem_spec.executables.each { |bin| BinWrapperEmitter.new(@gem_spec.name, bin).create_bin_wrapper! }
      end
      
      # Installs all dependencies and then the gem itself. Skips installation
      # if after installing the dependencies the gem is already installed.
      #
      # You can +force+ the gem to be installed even if the gem is already
      # installed.
      def install!(force = false)
        install_dependencies!(force)
        
        if !force && File.exist?(install_path)
          log(:debug, "Already installed `#{@gem_spec}'")
        else
          log(:info, "Installing `#{@gem_spec}'")
          download
          unpack
          
          replace(data_dir, install_path)
          replace(gem_file, gem_cache_file)
          
          create_bin_wrappers!
          create_ruby_gemspec!
        end
      end
      
      private
      
      def install_dependencies!(force)
        log(:debug, "Checking dependencies of `#{@gem_spec}'")
        @gem_spec.dependencies.each do |dep|
          log(:debug, "Checking dependency requirements of `#{dep}'")
          dep.gem_spec.install!(force) unless dep.meets_requirements?
        end
      end
    end
  end
end