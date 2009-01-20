module Gem
  module Micro
    class Source
      def self.sources
        @sources ||= []
      end
      
      def self.add_source(host, directory)
        sources << Source.new(host, directory)
      end
      
      def self.gem_spec(name, version)
        sources.map { |source| source.gem_spec(name, version) }
      end
      
      include Utils
      
      SPECS_FILE = "specs.4.8"
      SPECS_ARCHIVE_FILE = "#{SPECS_FILE}.gz"
      
      attr_reader :host
      
      # Initializes a Source with +host+ and the +directory+ where the index
      # should be.
      #
      #   s = Source.new('gems.rubyforge.org', '/path/to/gem/indices/')
      #   s.specs_url # => "http://gems.rubyforge.org/specs.4.8.gz"
      #   s.index_file # => "/path/to/indices/gems.rubyforge.org"
      def initialize(host, directory)
        @host, @directory = host, directory
      end
      
      # Returns the full path to the index file.
      def index_file
        File.join(@directory, @host)
      end
      
      # Returns the full path to the temporary work directory to where the
      # index should be unpacked.
      def work_index_file
        File.join(tmpdir, SPECS_FILE)
      end
      
      # Returns the full path to the temporary work directory to where the
      # index archive should be downloaded.
      def work_archive_file
        File.join(tmpdir, SPECS_ARCHIVE_FILE)
      end
      
      # Returns the url for the complete marshalled list of specs.
      def specs_url
        "http://#{@host}/#{SPECS_ARCHIVE_FILE}"
      end
      
      # Returns whether or not the index exists at index_file.
      def exist?
        File.exist?(index_file)
      end
      
      # Downloads and unpacks a index file to index_file.
      def get_index!
        Downloader.get(specs_url, work_index_file)
        Unpacker.gzip(work_archive_file)
        FileUtils.mv(work_index_file, index_file)
      end
      
      # Loads and returns an array of all gem names and versions.
      def specs
        @specs ||= Marshal.load(File.read(index_file))
      end
      
      # Returns a gem name and it's version matching the given +name+ and
      # +version+.
      def spec(name, version)
        specs.select { |spec| spec[0] == name && (version.any? || spec[1] == version) }.last
      end
      
      # Returns a Gem::Specification matching the given +name+ and +version+.
      def gem_spec(name, version)
        BareSpecification.new(self, name, version).gem_spec
      end
    end
  end
end