require 'fileutils'

module Gem
  module Micro
    class Downloader
      class DownloadError < StandardError; end
      
      def self.get_with_curl(remote, local)
        unless system("#{curl_binary} --silent --location --output '#{local}' '#{remote}'")
          raise DownloadError, "Failed to download `#{remote}' to `#{local}'"
        end
      end
      
      def self.get_with_net_http(remote, local)
        require 'net/http'
        require 'uri'
        
        uri = URI.parse(remote)
        response = Net::HTTP.start(uri.host, uri.port) do |http|
          http.get(uri.path)
        end
        
        case response.code
        when '200'
          FileUtils.mkdir_p(File.dirname(local))
          File.open(local, 'w') { |file| file.write(response.body) }
          response
        when '302'
          get_with_net_http(response.header['Location'], local)
        else
          raise DownloadError, "Failed to download `#{remote}' to `#{local}' (#{response.code})"
        end
      end
      
      def self.get(remote, local)
        if Config[:simple_downloader]
          self.get_with_curl(remote, local)
        else
          self.get_with_net_http(remote, local)
        end
      end
      
      def self.curl_binary
        '/usr/bin/curl'
      end
    end
  end
end