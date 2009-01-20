module Gem
  module Micro
    class Unpacker
      class UnpackError < StandardError; end
      
      extend Utils
      
      # Unpacks a tar +archive+ to +extract_to+ using the +tar+ commandline
      # utility. If +gzip+ is +true+ the archive is expected to be a gzip
      # archive and will be decompressed.
      #
      # Raises a Gem::Micro::Unpacker::UnpackError if it fails.
      def self.tar(archive, extract_to, gzip = false)
        log(:debug, "Unpacking `#{archive}' to `#{extract_to}'")
        ensure_dir(extract_to)
        unless system("/usr/bin/tar --directory='#{extract_to}' -#{ 'z' if gzip }xf '#{archive}' > /dev/null 2>&1")
          raise UnpackError, "Failed to unpack `#{archive}' with `tar'"
        end
      end
      
      # Unpacks a gzip +archive+ _in_ place using the +gunzip+ commandline
      # utility.
      #
      # Raises a Gem::Micro::Unpacker::UnpackError if it fails.
      #
      # TODO: Make it work _not_ in place.
      def self.gzip(archive)
        unless system("/usr/bin/gunzip -d '#{archive}' > /dev/null 2>&1")
          raise UnpackError, "Failed to unpack `#{archive}' with `gunzip'"
        end
      end
    end
  end
end