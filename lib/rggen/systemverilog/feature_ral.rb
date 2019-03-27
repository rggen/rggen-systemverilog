# frozen_string_literal: true

module RgGen
  module SystemVerilog
    class FeatureRAL < Feature
      private

      def create_variable(_, attributes, block)
        DataObject.new(
          :variable, attributes.merge(array_format: :unpacked), &block
        )
      end

      def create_parameter(_, attributes, block)
        DataObject.new(
          :parameter, attributes.merge(parameter_type: :parameter), &block
        )
      end

      define_entity :variable, :create_variable, :variable
      define_entity :parameter, :create_parameter, :parameter
    end
  end
end
