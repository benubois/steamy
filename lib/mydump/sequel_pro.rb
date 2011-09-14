require 'rubygems'
require 'plist'
require 'pp'

module Mydump
  class SequelPro
    
    attr_reader :connections
    
    def initialize
      @plist_dir = ""
      @connections = connections
    end
    
    def connections
      connections = {}
      
      Dir.chdir(@plist_dir)

      # For each vhost replace the DOCUMENT_ROOT and write back out to sites-enabled
      Dir.glob("*.spf") do |file|
         connection = Plist::parse_xml(file)
         connections[connection['data']['connection']['ssh_host']] = connection['data']['connection']
      end
      
      connections
    end
    
    def available_connections
      @connections.each do |index, data|
        puts index
      end
    end
    
  end
end