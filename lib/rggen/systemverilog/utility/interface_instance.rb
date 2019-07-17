# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Utility
      class InterfaceInstance
        include Core::Utility::AttributeSetter

        def initialize(**default_attributes)
          apply_attributes(default_attributes)
          block_given? && yield(self)
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

        alias_method :declaration, :instantiation

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
