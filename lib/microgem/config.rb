require 'rbconfig'

module Gem
  module Micro
    class Config
      class << self
        
        # Returns the full path to the Gem home directory.
        def gem_home
          @gem_home ||= Utils.ensure_dir(if ENV['PRODUCTION']
            sitelibdir = ::Config::CONFIG['sitelibdir']
            version = ::Config::CONFIG['ruby_version']
            File.expand_path("../../Gems/#{version}", sitelibdir)
          else
            File.expand_path("../../../tmp/gem_home", __FILE__)
          end)
        end
        
        # Returns the full path to the directory where the installed gems are.
        def gems_path
          @gems_path ||= Utils.ensure_dir(File.join(gem_home, 'gems'))
        end
        
        # Returns the full path to the directory where the installed gem specs
        # are.
        def specifications_path
          @specifications_path ||= Utils.ensure_dir(File.join(gem_home, 'specifications'))
        end
        
        # Returns the full path to the directory where the gems are cached.
        def cache_path
          @cache_path ||= Utils.ensure_dir(File.join(gem_home, 'cache'))
        end
        
        # Returns an array of source hosts from which to fetch gems.
        def sources
          %w{ gems.rubyforge.org gems.github.com }
        end
        
        attr_writer :log_level, :force, :simple_downloader, :simple_unpacker
        
        # Returns the current log level, which is +:info+ or +:debug+.
        def log_level
          @log_level ||= :info
        end
        
        # Returns whether or not actions should be forced.
        def force?
          @force ||= false
        end
        
        # Returns whether or not to use +curl+ instead of Net::HTTP.
        def simple_downloader?
          @simple_downloader ||= false
        end
        
        # Returns whether or not to use the external +xinflate+ instead of
        # Zlib::Inflate.inflate.
        def simple_unpacker?
          @simple_unpacker ||= false
        end
        
        # Merges the values from the +options+ hash.
        def merge!(options)
          options.each { |k,v| send("#{k}=", v) }
        end
      end
    end
  end
end