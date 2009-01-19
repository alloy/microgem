require 'optparse'

module Gem
  module Micro
    class Options
      DEFAULTS = {
        :log_level         => :info,
        :force             => false,
        :simple_downloader => false
      }
      
      attr_accessor :command, :arguments, :log_level, :force
      attr_accessor :simple_downloader
      
      def initialize
        DEFAULTS.each { |k,v| send("#{k}=", v) }
      end
      
      def parser
        @parser ||= OptionParser.new do |opts|
          opts.banner =  "Microgem is an unsophisticated package manager for Ruby."
          opts.separator "And the first commandline utility to start with a multibyte character; µ"
          opts.separator ""
          opts.separator "  Usage:"
          opts.separator "        µgem [command] [arguments…] [options…]"
          opts.separator ""
          opts.separator "  Example:"
          opts.separator "        µgem install rake"
          opts.separator "        µgem install rails --force"
          opts.separator "        µgem cache update --debug"
          opts.separator ""
          opts.separator "  Options:"
          
          opts.on("--debug", "Raises the log level to `debug'") do
            self.log_level = :debug
          end
          
          opts.on("--force", "Forces a command") do
            self.force = true
          end
          
          opts.on("--simple-downloader", "Use curl to download files instead of Net::HTTP") do
            self.simple_downloader = true
          end
          
          opts.on("--help", "Show help information") do
            puts opts
            exit
          end
          
        end
      end
      
      def banner
        parser.to_s
      end
      
      def parse(arguments)
        parser.parse! arguments
        self.command = arguments.shift
        self.arguments = arguments
        self
      end
    end
  end
end