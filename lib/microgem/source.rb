module Gem
  module Micro
    class Source
      include Utils
      
      SPECS_ARCHIVE_NAME = 'specs.4.8.gz'
      
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
      # index archive should be downloaded.
      def work_index_file
        File.join(tmpdir, SPECS_ARCHIVE_NAME)
      end
      
      # Returns the url for the complete marshalled list of specs.
      def specs_url
        "http://#{@host}/#{SPECS_ARCHIVE_NAME}"
      end
      
      # Returns whether or not the index exists at index_file.
      def exist?
        File.exist?(index_file)
      end
      
      # Downloads and unpacks a index file to index_file.
      def get_index!
        Gem::Micro::Downloader.get(specs_url, work_index_file)
        untar(work_index_file, index_file, true)
      end
    end
  end
end