require 'singleton'
require 'rbconfig'

module Gem
  module Micro
    class Config
      # Returns the full path to the Gem home directory.
      def self.gem_home
        if ENV['PRODUCTION']
          sitelibdir = ::Config::CONFIG['sitelibdir']
          version = ::Config::CONFIG['ruby_version']
          File.expand_path("../../Gems/#{version}", sitelibdir)
        else
          File.expand_path("../../../tmp/gem_home", __FILE__)
        end
      end
      
      # Returns an array of source hosts from which to fetch gems.
      def self.sources
        %w{ gems.rubyforge.org gems.github.com }
      end
    end
  end
end