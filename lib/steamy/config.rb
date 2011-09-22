require 'yaml'

module Steamy
  
  class Config
    
    FILE = "#{ENV['HOME']}/.steamy"
    
    def self.config
      if File.exist?(FILE)
        YAML.load_file(FILE)
      else
        puts "Please create a config file in #{ENV['HOME']}/.steamy"
        exit 1
      end
    end

  end

end