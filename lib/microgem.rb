require 'microgem/yamlable'

require 'microgem/dependency'
require 'microgem/installer'
require 'microgem/requirement'
require 'microgem/stubs'
require 'microgem/source_index'
require 'microgem/specification'
require 'microgem/version'

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