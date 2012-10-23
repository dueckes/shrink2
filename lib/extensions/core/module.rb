Module.class_eval do

  def contextless_name
    name.match(/[^:]*$/)[0]
  end

  def mandatory_cattr_accessor(*accessor_names)
    accessor_names.flatten.each do |accessor_name|
      self.instance_eval <<-CODE

        def #{accessor_name}
          value = self.instance_variable_get("@#{accessor_name}")
          raise "#{accessor_name} must be established" if value.nil?
          value
        end

        def set_#{accessor_name}(value)
          raise "#{accessor_name} must be provided" if value.nil?
          self.instance_variable_set("@#{accessor_name}", value)
        end

      CODE
    end
  end

end
