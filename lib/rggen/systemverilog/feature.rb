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

        def define_entity(entity, creation_method, declaration_type)
          context =
            EntityContext.new(entity, creation_method, declaration_type)
          define_method(entity) do |domain, name, **attributes, &block|
            declare_entity(context, domain, name, attributes, &block)
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

      def declare_entity(context, domain, name, **attributes, &block)
        merged_attributes = { name: name }.merge(attributes)
        entity = create_entity(context, merged_attributes, block)
        add_declaration(context, domain, entity)
        add_identifier(name, entity)
      end

      def create_entity(context, attributes, block)
        creation_method = context.creation_method
        entity_type = context.entity_type
        __send__(creation_method, entity_type, attributes, block)
      end

      def add_declaration(context, domain, entity)
        declaration_type = context.declaration_type
        @declarations[domain][declaration_type] << entity.declaration
      end

      def add_identifier(name, entity)
        export(name)
        instance_variable_set("@#{name}", entity.identifier)
        attr_singleton_reader(name)
      end
    end
  end
end
