# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class InterfacePort
        include Core::Utility::AttributeSetter

        def initialize(**default_attributes, &block)
          apply_attributes(default_attributes)
          block_given? && Docile.dsl_eval(self, &block)
        end

        define_attribute :name
        define_attribute :interface_type
        define_attribute :array_size

        def modport(name, ports = nil)
          @modport_name = name
          @modport_ports = ports
        end

        def declaration
          "#{port_type} #{port_identifier}"
        end

        def identifier
          Identifier.new(name) do |identifier|
            identifier.__array_size__(array_size)
            identifier.__sub_identifiers__(@modport_ports)
          end
        end

        private

        def port_type
          [@interface_type, @modport_name].compact.join('.')
        end

        def port_identifier
          [
            name, *Array(array_size).map { |size| "[#{size}]" }
          ].join
        end
      end
    end
  end
end
