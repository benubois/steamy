require "mydump/version"
require "mydump/config"
require "mydump/sequel_pro"
require "pp"

module Mydump
  class Mydump
    
    def initialize(host, database = nil)
      @settings = Config.config
      @settings[:saved_connections] = File.expand_path(@settings[:saved_connections])
      @host = host
      
      sequel_pro = SequelPro.new(@settings)
      @connections = sequel_pro.connections
      
      @ssh      = "ssh #{@connections[@host]['ssh_host']}"
      @user     = (@connections[@host]['user'].nil?) ? '' :  "-u #{@connections[@host]['user']}"
      @password = (@connections[@host]['password'].nil?) ? '' :  "-p#{@connections[@host]['password']}"
      @database = database
    end
    
    def remote_exec(command)
      # puts "#{@ssh} #{command}"
      `#{@ssh} '#{command}'`
    end
    
    def show_databases
      remote_exec(sprintf('\'mysql -e "show databases" %s %s\'', @user, @password))
    end
    
    def get_database
      databases = show_databases.split("\n")
      
      pp databases

      puts "Choose a database to dump:"
      databases.each_with_index do |db, i|
        unless 
          puts i.to_s + ': ' + db
        end
      end

      # Get index from user
      index = gets.to_i
      databases[index]
    end
    
    def mysqldump
      if @database.nil?
        @database = get_database
      end
      remote_exec(sprintf("mysqldump '%s %s %s | gzip -c' > ~/Desktop/db.sql", @user, @password, @database))
    end
    
  end
end



preview = Mydump::Mydump.new('', 'mysql')
preview.mysqldump
