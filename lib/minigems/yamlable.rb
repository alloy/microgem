require 'yaml'

module Gem
  module MiniGems
    # Mainly a MacRuby workaround, because yaml transfer is broken.
    class YAMLable
      class << self
        def inherited(subklass) #:nodoc:
          super
          
          subklass.class_eval do
            yaml_as "tag:ruby.yaml.org,2002:object:#{name}"
            
            def self.yaml_new(klass, tag, values)
              self[values]
            end
          end
        end
        
        # Initializes an instance and assigns the hash of +values+ as its
        # instance variables.
        #
        #   YAMLable[:foo => 'foo'] # => <#Gem::MiniGems::YAMLable:0x320154 @foo="foo">
        def [](values)
          object = new
          values.each { |k,v| object.send(:instance_variable_set, "@#{k}", v) }
          object
        end
      end
    end
  end
end