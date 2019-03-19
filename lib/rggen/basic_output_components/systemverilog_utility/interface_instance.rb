# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class InterfaceInstance
        include Core::Utility::AttributeSetter

        def initialize(**default_attributes, &block)
          apply_attributes(default_attributes)
          block_given? && Docile.dsl_eval(self, &block)
        end

        define_attribute :name
        define_attribute :interface_type
        define_attribute :parameter_values
        define_attribute :port_connections
        define_attribute :array_size
        define_attribute :variables

        def instantiation
          [
            interface_type,
            parameter_value_assignments,
            instance_identifier
          ].select(&:itself).join(' ')
        end

        def identifier
          Identifier.new(name) do |identifier|
            identifier.__array_size__(array_size)
            identifier.__sub_identifiers__(variables)
          end
        end

        private

        def parameter_value_assignments
          values = Array(parameter_values)
          values.size.positive? && "#(#{values.join(', ')})"
        end

        def instance_identifier
          [
            name,
            *Array(array_size).map { |size| "[#{size}]" },
            "(#{Array(port_connections).join(', ')})"
          ].join
        end
      end
    end
  end
end
