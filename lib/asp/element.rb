module Asp
  module Element
    def self.included(target)
      Asp::Memory.instance.remember(target)
      target.extend(ClassMethods)
    end

    module ClassMethods
      def from(string)
        self.new
      end
    end
  end
end
