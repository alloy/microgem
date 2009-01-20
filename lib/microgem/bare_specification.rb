module Gem
  module Micro
    class BareSpecification
      include Utils
      
      def initialize(source, name, version)
        @source, @name, @version = source, name, version
      end
      
      def gem_spec_url
        "http://#{@source.host}/quick/Marshal.4.8/#{@name}-#{@version}.gemspec.rz"
      end
      
      def gem_spec_work_file
        File.join(tmpdir, "#{@name}-#{@version}.gemspec")
      end
      
      def gem_spec_work_archive_file
        "#{gem_spec_work_file}.rz"
      end
      
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