require "mydump/version"
require "mydump/config"
require "mydump/sequel_pro"
require "pp"

module Mydump
  class Mydump
    
    def initialize(host = nil, database = nil)
      
      @settings = Config.config
      @settings[:saved_connections] = File.expand_path(@settings[:saved_connections])
      @host = host
      
      @sequel_pro = SequelPro.new(@settings)
      @connections = @sequel_pro.connections

      if @host.nil? || @connections[@host].nil?
        puts "no host #{@host}, available hosts:"
        list
        exit 1
      end
      
      @ssh      = "ssh #{@host}"
      @user     = (@connections[@host]['user'].nil?) ? '' :  "-u #{@connections[@host]['user']}"
      @password = (@connections[@host]['password'].nil?) ? '' :  "-p\"#{@connections[@host]['password']}\""
      @database = database
    end
    
    def remote_exec(command)
      command =  "#{@ssh} #{command}"
      `#{command}`
    end
    
    def show_databases
      remote_exec(sprintf('\'mysql -e "show databases" %s %s\'', @user, @password))
    end
    
    def list
      @sequel_pro.available_connections
    end
    
    def get_database
      databases = show_databases.split("\n")
      
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
      timestamp = Time.now.strftime("%Y-%m-%d_%H%M%S")
      name = "#{@host}_#{@database}_#{timestamp}.sql.gz"
      remote_exec("'mysqldump #{@user} #{@password} #{@database} | gzip -c' > ~/Desktop/#{name}")
    end
    
  end
end