module Steamy
  
  def self.config
    {
      :saved_connections => File.expand_path(yaml[:saved_connections])
    }
  end

  def self.yaml
    if File.exist?("#{ENV['HOME']}/.steamy")
      @yaml ||= YAML.load_file("#{ENV['HOME']}/.steamy")
    else
      {}
    end
  end

end