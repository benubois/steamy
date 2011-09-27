require "steamy/version"
require "steamy/config"
require "steamy/sequel_pro"

module Steamy
  class Steamy
    
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
      @database = set_database(host, database)
    end
    
    def set_database(host, database)
      if host.nil? || @connections[@host]['database'].nil? || database
        database = database
      else
        puts "This user can only access '#{@connections[@host]['database']}', update credentials to access other databases or specify database to dump."
        exit 1
      end
      
      database
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
        puts i.to_s + ': ' + db
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