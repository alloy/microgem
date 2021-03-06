require 'fileutils'
require 'tmpdir'

module Gem
  module Micro
    module Utils
      extend self
      
      # Returns the Config.
      def config
        Config
      end
      
      # Prints a +message+ to +stdout+ with the specified log +level+.
      #
      # TODO: Add proper Logger.
      def log(level, message)
        unless level == :debug && config.log_level != :debug
          puts "[#{level}] #{message}"
        end
      end
      
      # Creates a directory if it does not yet exist and it.
      def ensure_dir(dir)
        unless File.exist?(dir)
          log(:debug, "Creating directory `#{dir}'")
          FileUtils.mkdir_p(dir)
        end
        dir
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
    end
  end
end