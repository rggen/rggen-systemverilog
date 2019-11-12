# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      class Feature < Common::Feature
        private

        def create_variable(data_type, attributes, block)
          DataObject.new(
            :variable, attributes.merge(data_type: data_type), &block
          )
        end

        def create_interface(_, attributes, block)
          InterfaceInstance.new(attributes, &block)
        end

        def create_argument(direction, attributes, block)
          DataObject.new(
            :argument, attributes.merge(direction: direction), &block
          )
        end

        def create_interface_port(_, attributes, block)
          InterfacePort.new(attributes, &block)
        end

        def create_parameter(parameter_type, attributes, block)
          DataObject.new(
            :parameter, attributes.merge(parameter_type: parameter_type), &block
          )
        end

        [
          [:logic, :create_variable, :variable],
          [:interface, :create_interface, :variable],
          [:input, :create_argument, :port],
          [:output, :create_argument, :port],
          [:interface_port, :create_interface_port, :port],
          [:parameter, :create_parameter, :parameter],
          [:localparam, :create_parameter, :parameter]
        ].each do |entity, creation_method, declaration_type|
          define_entity(entity, creation_method, declaration_type)
        end
      end
    end
  end
end
