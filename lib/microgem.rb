require 'microgem/yamlable'
require 'microgem/utils'

require 'microgem/bare_specification'
require 'microgem/bin_wrapper_emitter'
require 'microgem/config'
require 'microgem/dependency'
require 'microgem/downloader'
require 'microgem/installer'
require 'microgem/options_parser'
require 'microgem/requirement'
require 'microgem/source'
require 'microgem/specification'
require 'microgem/specification_emitter'
require 'microgem/unpacker'
require 'microgem/version'

module Gem
  module Micro
    class << self
      include Utils
      
      # The main +run+ method which is used by the µgem script to perform the
      # actions specified by the user.
      def run(arguments)
        parser = OptionsParser.new
        parser.parse(arguments)
        Config.merge!(parser.options)
        
        case parser.command
        when 'install'
          gem_spec = Source.gem_spec(parser.arguments.first, Gem::Version[:version => '0'])
          gem_spec.install!
          
        when 'sources'
          case parser.arguments.first
          when 'update'
            Source.update!
            
          end
        else
          puts parser.banner
        end
      end
      
      # Returns an array of all installed gems their directory names,
      # optionally limited to gems matching the given +name+.
      def installed_gem_dirnames(name = nil)
        directories = Dir.glob(File.join(Config.gems_path, '*')).sort
        directories = directories.map { |dir| File.basename(dir) }
        
        name.nil? ? directories : directories.select { |dirname| dirname =~ /^#{name}-[\d\.]+/ }
      end
    end
  end
end