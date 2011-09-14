require 'yaml'

module Mydump
  
  class Config
    
    FILE = "#{ENV['HOME']}/.mydump"
    
    def self.config
      if File.exist?(FILE)
        YAML.load_file(FILE)
      else
        puts "Please create a config file in #{ENV['HOME']}/.mydump"
        exit 1
      end
    end

  end

end