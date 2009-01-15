require 'minigems/yamlable'

require 'minigems/dependency'
require 'minigems/installer'
require 'minigems/requirement'
require 'minigems/stubs'
require 'minigems/source_index'
require 'minigems/specification'
require 'minigems/version'

module Gem
  module Micro
    class << self
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