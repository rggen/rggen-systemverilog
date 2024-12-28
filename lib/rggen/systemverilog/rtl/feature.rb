# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      class Feature < Common::Feature
        private

        def create_variable(data_type, attributes, &)
          DataObject.new(:variable, attributes.merge(data_type:), &)
        end

        def create_if_instance(_, attributes, &)
          InterfaceInstance.new(attributes, &)
        end

        def create_port(direction, attributes, &)
          attributes =
            { data_type: 'logic' }
              .merge(attributes)
              .merge(direction:)
          DataObject.new(:argument, attributes, &)
        end

        def create_if_port(_, attributes, &)
          InterfacePort.new(attributes, &)
        end

        def create_parameter(parameter_type, attributes, &)
          DataObject.new(:parameter, attributes.merge(parameter_type:), &)
        end

        define_entity :logic, :create_variable, :variable, -> { component }
        define_entity :interface, :create_if_instance, :variable, -> { component }
        define_entity :input, :create_port, :port, -> { register_block }
        define_entity :output, :create_port, :port, -> { register_block }
        define_entity :interface_port, :create_if_port, :port, -> { register_block }
        define_entity :parameter, :create_parameter, :parameter, -> { register_block }
        define_entity :localparam, :create_parameter, :parameter, -> { component }
      end
    end
  end
end
