module InstanceCounter
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
    base.instance_variable_set(:@instances_count, 0)
  end

  module InstanceMethods
  end

  module ClassMethods
    def instances
      @instances_count
    end

    def register_instance
      self.instances_count = instances + 1
    end

    protected

    attr_writer :instances_count

    private

    def inherited(subclass)
      subclass.instance_variable_set(:@instances_count, 0)
    end
  end
end
