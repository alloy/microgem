require 'yaml'

module Gem
  module MiniGems
    # MacRuby workaround, because yaml transfer is broken
    class YAMLable
      class << self
        def inherited(subklass)
          super
          
          subklass.class_eval do
            yaml_as "tag:ruby.yaml.org,2002:object:#{name}"
            
            def self.yaml_new(klass, tag, values)
              object = new
              values.each { |k,v| object.send(:instance_variable_set, "@#{k}", v) }
              object
            end
          end
        end
      end
    end
  end
end