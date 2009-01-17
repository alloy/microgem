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
        puts "[#{level}] #{message}"
      end
      
      # Returns a temporary directory and ensures it exists.
      #
      #   File.exist?('/path/to/tmp/microgem') # => false
      #   tmpdir # => '/path/to/tmp/microgem'
      #   File.exist?('/path/to/tmp/microgem') # => true
      def tmpdir
        tmpdir = File.join(Dir.tmpdir, 'microgem')
        FileUtils.mkdir(tmpdir) unless File.exist?(tmpdir)
        tmpdir
      end
    end
  end
end