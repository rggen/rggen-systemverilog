# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RAL
      class Feature < Common::Feature
        private

        def create_variable(_, attributes, block)
          DataObject.new(
            :variable, attributes.merge(array_format: :unpacked), &block
          )
        end

        def create_parameter(_, attributes, block)
          DataObject.new(
            :parameter, attributes, &block
          )
        end

        define_entity :variable, :create_variable, :variable
        define_entity :parameter, :create_parameter, :parameter
      end
    end
  end
end
