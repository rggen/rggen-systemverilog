# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogRTL
      class Feature < Core::OutputBase::Feature
        include SystemVerilogUtility

        def initialize(component, feature_name, &block)
          super(component, feature_name, &block)
          @declarations = Hash.new do |h0, k0|
            h0[k0] = Hash.new { |h1, k1| h1[k1] = [] }
          end
        end

        def declarations(domain, type)
          @declarations[domain][type]
        end

        private

        def __declare_entity__(domain, handle_name, **attributes, &block)
          merged_attributes = { name: handle_name }.merge(attributes)
          entity = create_entity(__callee__, merged_attributes, block)
          add_declaration(__callee__, domain, entity)
          add_identifier(handle_name, entity)
        end

        RenameMapper = Struct.new(:creation, :declaration)

        RENAME_MAPPERS = {
          logic: RenameMapper.new(:create_variable, :variable),
          interface: RenameMapper.new(:create_interface, :variable),
          input: RenameMapper.new(:create_argument, :port),
          output: RenameMapper.new(:create_argument, :port),
          interface_port: RenameMapper.new(:create_interface_port, :port),
          parameter: RenameMapper.new(:create_parameter, :parameter),
        }.freeze

        def create_entity(type, attributes, block)
          __send__(RENAME_MAPPERS[type].creation, type, attributes, &block)
        end

        def create_interface(_, attributes, &block)
          InterfaceInstance.new(attributes, &block)
        end

        def create_interface_port(_, attributes, &block)
          InterfacePort.new(attributes, &block)
        end

        def add_declaration(type, domain, entity)
          declaration_type = RENAME_MAPPERS[type].declaration
          @declarations[domain][declaration_type] << entity.declaration
        end

        def add_identifier(handle_name, entity)
          export(handle_name)
          instance_variable_set("@#{handle_name}", entity.identifier)
          attr_singleton_reader(handle_name)
        end

        RENAME_MAPPERS.each_key do |definition|
          alias_method definition, :__declare_entity__
        end
      end
    end
  end
end
