class Flickrcaptionr::Config
  # TODO: DRY this out.
  def initialize(config_path, user_options={})
    user_options.delete_if{|k,v|v == nil or v == ''}
    config_path = File.expand_path(config_path)
    @@defaults = {flickr_api_key:'', output_path: ''}
    config = YAML.load(open(config_path).read()) rescue nil
    if config
      @@config = config
      if user_options != {} and not user_options == nil
        user_options.each_pair do |k,v|
          @@config[k] = v
        end
        File.open(config_path, 'w'){|f|f<<YAML.dump(@@config)}
      end
    else
      begin
        if user_options != {} and not user_options == nil
          user_options.each_pair do |k,v|
            @@config[k] = v
          end
        end
        File.open(config_path, 'w'){|f|f<<YAML.dump(@@defaults)}
      rescue Exception => e
        raise ArgumentError, "Couldn't write a default config file! Check the config file path is writeable (#{e.inspect})."
      end
    end
    puts "Configuration: "+@@config.inspect
  end
  def self.method_missing(method_name, *args, &block)
    return @@config[method_name.to_sym] rescue nil
  end
end