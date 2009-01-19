module Gem
  module Micro
    class Downloader
      class DownloadError < StandardError; end
      
      def self.get(remote, local)
        unless system("#{curl_binary} --silent --location --output '#{local}' '#{remote}'")
          raise DownloadError, "Failed to download `#{remote}' to `#{local}'"
        end
      end
      
      def self.curl_binary
        '/usr/bin/curl'
      end
    end
  end
end