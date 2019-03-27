# frozen_string_literal: true

module RgGen
  module SystemVerilog
    class Feature < Core::OutputBase::Feature
      include Utility
      template_engine Core::OutputBase::ERBEngine

      EntityContext =
        Struct.new(:entity_type, :creation_method, :declaration_type)

      class << self
        private

        def define_entity(entity_type, creation_method, declaration_type)
          context =
            EntityContext.new(entity_type, creation_method, declaration_type)
          define_method(entity_type) do |domain, name, **attributes, &block|
            entity =
              create_entity(context, { name: name }.merge(attributes), block)
            add_entity(entity, context, domain, name)
          end
        end
      end

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

      def create_entity(context, attributes, block)
        creation_method = context.creation_method
        entity_type = context.entity_type
        __send__(creation_method, entity_type, attributes, block)
      end

      def add_entity(entity, context, domain, name)
        add_declaration(context, domain, entity.declaration)
        add_identifier(name, entity.identifier)
      end

      def add_declaration(context, domain, declaration)
        declaration_type = context.declaration_type
        @declarations[domain][declaration_type] << declaration
      end

      def add_identifier(name, identifier)
        instance_variable_set("@#{name}", identifier)
        attr_singleton_reader(name)
        export(name)
      end
    end
  end
end
