module Gem
  class SourceIndex < MiniGems::YAMLable
    def self.load_from_file(file)
      YAML.load(open(file))
    end
    
    attr_reader :gems
    
    def gem_specs(name)
      @gems.select do |name_and_version, _|
        name_and_version =~ /^#{name}-[\d\.]+/
      end.map { |ary| ary.last }
    end
  end
end