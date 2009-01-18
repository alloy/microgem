require 'fileutils'
require 'tmpdir'

module Gem
  module Micro
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
      
      # Removes +to+, if it exists, before moving +from+ to +to+.
      def replace_dir(from, to)
        log(:debug, "Moving `#{from}' to `#{to}'")
        FileUtils.rm_rf(to) if File.exist?(to)
        FileUtils.mv(from, to)
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