# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTLPackage
      class Feature < Common::Feature
        private

        def full_name(separator = '_')
          component.full_name(separator)
        end

        def create_parameter(parameter_type, attributes, &)
          attributes =
            attributes.merge(
              parameter_type:, array_format: :unpacked,
              name: attributes[:name].upcase
            )
          DataObject.new(
            :parameter, attributes, &
          )
        end

        define_entity :localparam, :create_parameter, :parameter, -> { register_block }
      end
    end
  end
end
