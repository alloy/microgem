module Gem
  class SourceIndex < MiniGems::YAMLable
    def self.load_from_file(file)
      YAML.load(open(file))
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