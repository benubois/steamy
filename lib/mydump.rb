require "mydump/version"
require "mydump/config"
require "mydump/sequel_pro"
require "pp"

module Mydump
  class Mydump
    
    def initialize(host)
      @settings = Config.config
      @settings[:saved_connections] = File.expand_path(@settings[:saved_connections])
      @host = host
      
      sequel_pro = SequelPro.new(@settings)
      @connections = sequel_pro.connections
      
      @ssh = "ssh #{@connections[@host]['ssh_host']}"
    end
    
    def remote_exec(command)
      puts `#{@ssh} '#{command}'`
    end
    
    def show_databases
      remote_exec('mysql -e "show databases" -u ' + @connections[@host]['user'] + ' -p' + @connections[@host]['password'])
    end
    
    def mysqldump
      remote_exec("mysqldump -u #{@connections[@host]['user']} -p#{@connections[@host]['password']} #{@database} | gzip -c")
    end
  end
end



preview = Mydump::Mydump.new('')
preview.show_databases
