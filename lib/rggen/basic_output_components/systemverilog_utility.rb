# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      include Core::Utility::CodeUtility

      private

      def assign(lhs, rhs)
        "assign #{lhs} = #{rhs};"
      end

      def concat(expressions)
        "{#{Array(expressions).join(', ')}}"
      end

      def array(expressions)
        "'#{concat(expressions)}"
      end

      def bin(value, width = nil)
        if width
          width = bit_width(value, width)
          format("%d'b%0*b", width, width, value)
        else
          format("'b%b", value)
        end
      end

      def dec(value, width = nil)
        if width
          width = bit_width(value, width)
          format("%0d'd%d", width, value)
        else
          format("'d%d", value)
        end
      end

      def hex(value, width = nil)
        if width
          width = bit_width(value, width)
          print_width = (width + 3) / 4
          format("%0d'h%0*x", width, print_width, value)
        else
          format("'h%x", value)
        end
      end

      def bit_width(value, width)
        bit_length = value.bit_length
        bit_length = 1 if bit_length.zero?
        [width, bit_length].max
      end

      def create_variable(data_type, attributes, &block)
        DataObject.new(
          :variable, attributes.merge(data_type: data_type), &block
        )
      end

      def create_argument(direction, attributes, &block)
        DataObject.new(
          :argument, attributes.merge(direction: direction), &block
        )
      end

      def create_parameter(parameter_type, attributes, &block)
        DataObject.new(
          :parameter, attributes.merge(parameter_type: parameter_type), &block
        )
      end
    end
  end
end
