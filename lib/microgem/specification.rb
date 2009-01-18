module Gem
  class Specification < Micro::YAMLable
    attr_reader :name, :version, :dependencies
    
    # Returns the Specification's dirname:
    #
    #   rake.gem_dirname # => "rake-0.8.1"
    def gem_dirname
      "#{name}-#{version}"
    end
    alias_method :to_s, :gem_dirname
    
    # Returns the Specification's filename:
    #
    #   rake.gem_filename # => "rake-0.8.1.gem"
    def gem_filename
      "#{gem_dirname}.gem"
    end
    
    # Installs the gem for this Specification.
    def install!
      Micro::Installer.new(self).install!
    end
    
    def inspect
      "#<Gem::Specification:#{object_id} name=\"#{name}\" version=\"#{version}\">"
    end
    
    def to_ruby
%{Gem::Specification.new do |s|
  s.name = "#{name}"
  s.version = "#{version}"

  s.specification_version = 2 if s.respond_to? :specification_version=
end}
    end
  end
end