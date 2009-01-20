module Gem
  module Micro
    class Source
      include Utils
      
      SPECS_FILE = "specs.4.8"
      SPECS_ARCHIVE_FILE = "#{SPECS_FILE}.gz"
      
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
      
      def specs
        @specs ||= Marshal.load(File.read(index_file))
      end
      
      def spec(name, version)
        specs.select { |spec| spec[0] == name && (version.any? || spec[1] == version) }.last
      end
      
      # TODO: This should all move to a ‘bare’ spec class:
      
      def gem_spec_url(name, version)
        "http://#{@host}/quick/Marshal.4.8/#{name}-#{version}.gemspec.rz"
      end
      
      def gem_spec_work_file(name, version)
        File.join(tmpdir, "#{name}-#{version}.gemspec")
      end
      
      def gem_spec_work_archive_file(name, version)
        "#{gem_spec_work_file(name, version)}.rz"
      end
      
      def gem_spec(name, version)
        spec = spec(name, version)
        archive = gem_spec_work_archive_file(name, version)
        gemspec = gem_spec_work_file(name, version)
        
        Downloader.get(gem_spec_url(name, version), archive)
        Unpacker.inflate(archive, gemspec)
        
        Marshal.load(File.read(gemspec))
      end
    end
  end
end