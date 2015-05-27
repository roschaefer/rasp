module Asp
  class Constraint
    class Same
      attr_reader :attributes
      attr_reader :classes

      def initialize(*attributes)
        @attributes = attributes
      end


      def attribute_hash
        attribute_hash = {}
        self.attributes.each_with_index do |a, i|
          attribute_hash[a] = "#{a.to_s.upcase}#{i}"
        end
        attribute_hash
      end

      def for(*classes)
        @classes = classes
        self.asp
      end

      def asp
        self.classes.map{ |c| c.asp(self.attribute_hash) }.join(", ")
      end

    end
  end
end
