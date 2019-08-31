module Accessors
  def attr_accessor_with_history(*vars)
    vars.each do |name|
      define_method("#{name}") do
        instance_variable_get("@#{name}")
      end
      define_method("#{name}=") do |value|
        old_value = instance_variable_get("@#{name}")
        if instance_variable_get("@#{name}")
          send("#{name}_history").push(old_value)
        else
          instance_variable_set("@#{name}_history", [])
        end
        instance_variable_set("@#{name}", value)
      end
      define_method("#{name}_history") do
        instance_variable_get("@#{name}_history")
      end
    end
  end

  def strong_attr_accessor(var, type)
    define_method("#{var}") do
      instance_variable_get("@#{var}")
    end
    define_method("#{var}=") do |value|
      unless type.to_s == value.class.to_s
        raise "Wrong type of new value! #{type} is required!"
      end

      instance_variable_set("@#{var}", value)
    end
  end
end
