require "mydump/version"
require "mydump/config"
require "mydump/sequel_pro"

module Mydump
  class Mydump
    
    def initialize(host)
      @host = host
      sequel_pro = SequelPro.new
      @connections = sequel_pro.connections
    end
    
    def build_command
      system "ssh #{@connections[@host]['ssh_host']} 'mysqldump -u #{@connections[@host]['user']} -p#{@connections[@host]['password']} drupal | gzip -c'"
    end
  end
end



preview = Mydump::Mydump.new('')
print preview.build_command
