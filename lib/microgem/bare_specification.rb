module Gem
  module Micro
    class BareSpecification
      include Utils
      
      def initialize(source, name, version)
        @source, @name, @version = source, name, version
      end
      
      # Returns the url from where the gemspec should be downloaded.
      def gem_spec_url
        "http://#{@source.host}/quick/Marshal.4.8/#{@name}-#{@version}.gemspec.rz"
      end
      
      # Returns the full path to the gemspec file in the temporary work
      # directory.
      def gem_spec_work_file
        File.join(tmpdir, "#{@name}-#{@version}.gemspec")
      end
      
      # Returns the full path to the archive containing the gemspec file in the
      # temporary work directory.
      def gem_spec_work_archive_file
        "#{gem_spec_work_file}.rz"
      end
      
      # Retrieves the gem spec from gem_spec_url and loads the marshalled data.
      #
      # The returned Gem::Specification instance knows to which
      # Gem::Micro::Source it belongs.
      def gem_spec
        Downloader.get(gem_spec_url, gem_spec_work_archive_file)
        Unpacker.inflate(gem_spec_work_archive_file, gem_spec_work_file)
        gem_spec = Marshal.load(File.read(gem_spec_work_file))
        gem_spec.source = @source
        gem_spec
      end
    end
  end
end