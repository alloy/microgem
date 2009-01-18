require 'fileutils'

module Gem
  module Micro
    class SourceIndexFileTree
      class Node
        # Returns the dirname.
        #
        #   rake_node.dirname # => 'rake-0.8.1'
        attr_reader :dirname
        
        # Initializes a new Node which knows where on disk to look for a YAML
        # gem spec file and how to create one.
        #
        # With a String:
        #
        #   node = Node.new('/root', 'rake-0.8.1')
        #   node.full_path # => "/root/r/rake-0.8.1.yaml"
        #
        # With a Gem::Specification:
        #
        #   node = Node.new('/root', rake_gem_spec)
        #   node.full_path # => "/root/r/rake-0.8.1.yaml"
        #
        #   File.exist?(node.full_path) # => false
        #   node.create_gem_spec_file!
        #   File.exist?(node.full_path) # => true
        def initialize(root_path, dirname_or_gem_spec)
          @root_path = root_path
          
          if dirname_or_gem_spec.is_a?(String)
            @dirname = dirname_or_gem_spec
          else
            @gem_spec = dirname_or_gem_spec
            @dirname = @gem_spec.gem_dirname
          end
        end
        
        # Returns the path of the namespaced directory.
        #
        #   rake_node.namespaced_directory # => '/root/r'
        def namespaced_directory
          File.join(@root_path, @dirname[0,1].downcase)
        end
        
        # Returns the full path to the YAML gem spec file.
        #
        #   rake_node.full_path # => '/root/r/rake-0.8.1'
        def full_path
          File.join(namespaced_directory, "#{@dirname}.yaml")
        end
        
        def exist?
          File.exist? full_path
        end
        
        # Returns the Gem::Specification for this Node.
        def gem_spec
          @gem_spec ||= YAML.load(File.read(full_path))
        end
        
        # Creates a YAML file for this Node's Gem::Specification at full_path.
        def create_gem_spec_file!
          return if File.exist?(full_path)
          Utils.log(:debug, "Creating gem spec YAML file `#{full_path}'")
          FileUtils.mkdir_p(namespaced_directory) unless File.exist?(namespaced_directory)
          File.open(full_path, 'w') { |f| f << YAML.dump(@gem_spec) }
        end
      end
      
      # Creates a new SourceIndexFileTree at +path+ for the +source_index+.
      #
      # For each gem spec in the +source_index+ a YAML file will be created.
      # The directory layout that is created looks like:
      #
      #   root/
      #   root/a/activerecord-2.1.0
      #   root/a/activerecord-2.1.1
      #   root/r/
      #   root/r/rails-2.1.0
      #   root/r/rails-2.1.1
      #   root/r/rake-0.8.1
      #
      # The main reason for this type of cache is to speed up the gem querying
      # in a as simple possible way.
      def self.create(root_path, source_index)
        Utils.log(:info, "Creating source index file tree in `#{root_path}'")
        
        index = new(root_path)
        source_index.gems.each do |_, gem_spec|
          node = Node.new(root_path, gem_spec)
          node.create_gem_spec_file!
          index.add_node(node)
        end
        index
      end
      
      # Initializes a SourceIndexFileTree with a given +root_path+.
      # This should _only_ be used for an existing file tree.
      def initialize(root_path)
        @root_path = root_path
        @nodes = {}
      end
      
      # Adds a Node to the index.
      def add_node(node)
        @nodes[node.dirname] = node
      end
      
      # Returns a node if a gem spec file for it exists. The +dirname+ should
      # be a name and version string like: <tt>"rake-0.8.1"</tt>.
      def [](dirname)
        if node = @nodes[dirname]
          node
        else
          node = Node.new(@root_path, dirname)
          @nodes[dirname] = node if node.exist?
        end
      end
    end
  end
end