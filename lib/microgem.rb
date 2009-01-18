require 'microgem/yamlable'
require 'microgem/utils'

require 'microgem/dependency'
require 'microgem/installer'
require 'microgem/options'
require 'microgem/requirement'
require 'microgem/stubs'
require 'microgem/source_index'
require 'microgem/source_index_file_tree'
require 'microgem/specification'
require 'microgem/version'

module Gem
  module Micro
    class << self
      include Utils
      
      def config
        config = {}
        
        if ENV['PRODUCTION']
          require 'rbconfig'
          sitelibdir = ::Config::CONFIG['sitelibdir']
          version = ::Config::CONFIG['ruby_version']
          config[:gem_home] = File.expand_path("../../Gems/#{version}", sitelibdir)
        else
          config[:gem_home] = File.expand_path("../../tmp/gem_home", __FILE__)
        end
        
        config[:gem_source_url]        = 'http://gems.rubyforge.org/gems/'
        config[:log_level]             = Options::DEFAULTS[:log_level]
        config[:microgem_source_index] = File.join(config[:gem_home], 'microgem_source_index')
        config[:source_index_path]     = File.join(config[:gem_home], 'source_index.yaml') # where does rubygems store this file?
        config[:install_dir]           = File.join(config[:gem_home], 'gems')
        
        config
      end
      
      def load_source_index
        SourceIndex.load_from_file Config[:source_index_path]
      end
      
      def source_index
        @source_index ||= if File.exist?(Config[:microgem_source_index])
          log(:debug, "Loading source index file tree `#{Config[:microgem_source_index]}'")
          SourceIndexFileTree.new Config[:microgem_source_index]
        else
          log(:debug, "Loading YAML source index `#{Config[:source_index_path]}'")
          SourceIndex.load_from_file Config[:source_index_path]
        end
      end
      
      def run(arguments)
        options = Options.new
        options.parse(arguments)
        
        Config[:log_level] = options.log_level
        
        case options.command
        when 'install'
          gem_spec = source_index.gem_specs(options.arguments.first).last
          gem_spec.install!
          
        when 'cache'
          load_source_index
          root = File.join(Config[:gem_home], 'microgem_source_index')
          FileUtils.rm_rf(root) if File.exist?(root)
          Gem::Micro::SourceIndexFileTree.create(root, Gem::SourceIndex.instance)
          
        else
          puts options.banner
        end
      end
      
      # Returns an array of all installed gems their directory names,
      # optionally limited to gems matching the given +name+.
      def installed_gem_dirnames(name = nil)
        directories = gem_paths.map { |dir| Dir.glob(File.join(dir, '*')) }.flatten.sort
        directories = directories.map { |dir| File.basename(dir) }
        
        name.nil? ? directories : directories.select { |dirname| dirname =~ /^#{name}-[\d\.]+/ }
      end
      
      def gem_paths
        []
      end
    end
    
    # Loads the configuration via Gem::Micro.config.
    Config = self.config
  end
end