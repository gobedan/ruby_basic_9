module Validation
  def self.included(base)
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    attr_reader :validations 

    def validate(var, type, *arg)
      @validations ||= []
      @validations.push({:var => var, :type => type, :arg => arg})
    end
  end

  module InstanceMethods
    def validate! 
      self.class.validations.each do |validation|
        send(validation[:type], instance_variable_get("@#{validation[:var]}"), validation[:arg])  
      end
    end

    def valid? 
      validate!
      true
    rescue
      false
    end

    private

    def presenece(var)
      raise "Variable #{var} is empty! " if var.isNil? || var == ''
    end

    def type(var, type)
      raise "Wrong type of variable! #{var} must be #{type}" unless var.class.is_a? type 
    end

    def format(var, pattern)
      raise "Wrong #{var} format!" unless var =~ pattern 
    end
  end
end
