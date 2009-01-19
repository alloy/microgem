require 'fileutils'
require 'tmpdir'

module Gem
  module Micro
    class UnpackError < StandardError; end
    
    module Utils
      extend self
      
      # Prints a +message+ to +stdout+ with the specified log +level+.
      #
      # TODO: Add proper Logger.
      def log(level, message)
        unless level == :debug && Config[:log_level] != :debug
          puts "[#{level}] #{message}"
        end
      end
      
      # Creates a directory if it does not yet exist.
      def ensure_dir(dir)
        FileUtils.mkdir_p(dir) unless File.exist?(dir)
      end
      
      # Removes +new_path+, if it exists, before moving +old_path+ to +to+.
      def replace(old_path, new_path)
        log(:debug, "Moving `#{old_path}' to `#{new_path}'")
        FileUtils.rm_rf(new_path) if File.exist?(new_path)
        FileUtils.mv(old_path, new_path)
      end
      
      # Returns a temporary directory and ensures it exists.
      #
      #   File.exist?('/path/to/tmp/microgem') # => false
      #   tmpdir # => '/path/to/tmp/microgem'
      #   File.exist?('/path/to/tmp/microgem') # => true
      def tmpdir
        tmpdir = File.join(Dir.tmpdir, 'microgem')
        ensure_dir(tmpdir)
        tmpdir
      end
      
      # Unpacks an archive from +file+ to +to+ using the +tar+ commandline
      # utility. If +gzip+ is +true+ the archive is expected to be a gzip
      # archive and will be decompressed.
      #
      # Raises a Gem::Micro::UnpackError if it fails.
      def untar(file, to, gzip = false)
        log(:debug, "Unpacking `#{file}' to `#{to}'")
        ensure_dir(to)
        unless system("/usr/bin/tar --directory='#{to}' -#{ 'z' if gzip }xf '#{file}' > /dev/null 2>&1")
          raise UnpackError, "Failed to unpack `#{file}': #{$?}"
        end
      end
    end
  end
end