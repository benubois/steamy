require 'rubygems'
require 'plist'
require 'pp'

module Steamy
  class SequelPro
    
    attr_reader :connections
    
    def initialize(settings)
      @settings = settings
      @connections = connections
    end
    
    def connections
      connections = {}
      
      Dir.chdir(@settings[:saved_connections])

      # For each vhost replace the DOCUMENT_ROOT and write back out to sites-enabled
      Dir.glob("*.spf") do |file|
         connection = Plist::parse_xml(file)
         connections[connection['data']['connection']['ssh_host']] = connection['data']['connection']
      end
      
      connections
    end
    
    def available_connections
      keys = @connections.keys
      keys.reject! { |name| name.nil? }
      keys.sort!
      keys.each do |name|
        puts name
      end
    end
    
  end
end