# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class InterfacePort
          include Core::Utility::AttributeSetter

          def initialize(default_attributes = {})
            apply_attributes(**default_attributes)
            block_given? && yield(self)
          end

          define_attribute :name
          define_attribute :interface_type
          define_attribute :modport
          define_attribute :array_size

          def modport(name_and_ports, ports = nil)
            @modport_name, @modport_ports =
              if ports
                [name_and_ports, ports]
              else
                Array(name_and_ports)[0..1]
              end
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
end
