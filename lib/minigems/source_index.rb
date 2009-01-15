module Gem
  class SourceIndex < MiniGems::YAMLable
    class << self
      attr_reader :instance
      
      def load_from_file(file)
        index = YAML.load(open(file))
        @instance = index
        index
      end
    end
    
    attr_reader :gems
    
    # Returns the gem specs matching the given +name+ and sorted by version.
    def gem_specs(name)
      gems.select { |_, spec| spec.name == name }.
        map { |ary| ary.last }.
          sort_by { |spec| spec.version.to_s }
    end
  end
end