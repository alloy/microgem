require 'microgem/yamlable'
require 'microgem/utils'

require 'microgem/dependency'
require 'microgem/installer'
require 'microgem/options'
require 'microgem/requirement'
require 'microgem/stubs'
require 'microgem/source_index'
require 'microgem/specification'
require 'microgem/version'

module Gem
  module Micro
    Gem::Micro::Config = {
      :source_index_path => File.expand_path("../../tmp/source_index.yaml", __FILE__),
      :gem_source_url    => 'http://gems.rubyforge.org/gems/',
      :install_dir       => File.expand_path("../../tmp/gems", __FILE__),
      :log_level         => Options::DEFAULTS[:log_level]
    }
    
    class << self
      def load_source_index
        SourceIndex.load_from_file Config[:source_index_path]
      end
      
      def run(arguments)
        options = Options.new
        options.parse(arguments)
        
        Config[:log_level] = options.log_level
        
        case options.command
        when 'install'
          load_source_index # TODO: this should happen lazily
          
          gem_spec = SourceIndex.instance.gem_specs(options.arguments.first).last
          gem_spec.install!
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
  end
end