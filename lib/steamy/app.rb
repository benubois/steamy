module Steamy  
  class App
    
    def initialize(host = nil, database = nil)
        @host = host
        @database = database
        
        @user = ''
        @password = ''
      
        @sequel_pro = SequelPro.new()
        @connections = @sequel_pro.connections
    end
    
    def dump
        setup_connection
        
        if @database.nil?
          @database = get_database
        end
        
        timestamp = Time.now.strftime("%Y-%m-%d_%H%M%S")
        name = "#{@host}_#{@database}_#{timestamp}.sql.gz"
        remote_exec("'mysqldump #{@user} #{@password} #{@database} | gzip -c' > ~/Desktop/#{name}")
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
    
    def setup_connection
      if @host.nil? || @connections[@host].nil?
        if @host.nil?
          puts "no host, available hosts:"
        else 
          puts "no host #{@host}, available hosts:"
        end
        @sequel_pro.list
        exit 1
      end
      
      unless @connections[@host]['user'].empty?
        @user = "-u #{@connections[@host]['user']}"
      end
      
      unless @connections[@host]['password'].empty?
        @password = "-p\"#{@connections[@host]['password']}\""
      end

      @database = set_database(@host, @database)
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
    
    def show_databases
      remote_exec(sprintf('\'mysql -e "show databases" %s %s\'', @user, @password))
    end
    
    def remote_exec(command)
      command =  "ssh #{@host} #{command}"
      `#{command}`
    end
    
    def available_databases
      setup_connection
      puts show_databases
    end
    
  end
end