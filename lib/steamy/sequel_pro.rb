require 'plist'

module Steamy
  class SequelPro
    
    attr_reader :connections
    
    def initialize
      @connections = connections
    end
    
    def connections
      connections = {}
      
      Dir.chdir(Steamy.config[:saved_connections])

      # For each vhost replace the DOCUMENT_ROOT and write back out to sites-enabled
      Dir.glob("*.spf") do |file|
         connection = Plist::parse_xml(file)
         unless connection['data']['connection']['ssh_host'].nil?
           connections[connection['data']['connection']['ssh_host']] = connection['data']['connection']
         end
      end
      
      connections
    end
    
    def available_connections
      keys = @connections.keys
      keys.sort!
    end
    
    def list
      available_connections.each do |connection|
        puts connection
      end
    end
    
  end
end