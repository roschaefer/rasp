module Asp
  class Memory
    def initialize
      @element_classes = [] # array of classes that include Asp::Element
    end

    @@instance = Memory.new

    def remember(aclass)
      @element_classes << aclass
    end

    def well_known_classes
      @element_classes
    end

    def forget!
      @element_classes = []
    end

    def self.instance
      return @@instance
    end

    private_class_method :new

  end
end
