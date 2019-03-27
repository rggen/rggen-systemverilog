# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilog
      class Feature < Core::OutputBase::Feature
        include SystemVerilogUtility
        template_engine Core::OutputBase::ERBEngine

        class << self
          def creation_method(entity)
            @creation_methods[entity]
          end

          def declaration_type(entity)
            @declaration_types[entity]
          end

          private

          def define_entity(entity, creation_method, declaration_type)
            (@creation_methods ||= {})[entity] = creation_method
            (@declaration_types ||= {})[entity] = declaration_type
            define_method(entity) do |domain, name, **attributes, &block|
              declare_entity(__method__, domain, name, attributes, &block)
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

        def declare_entity(entity_type, domain, name, **attributes, &block)
          merged_attributes = { name: name }.merge(attributes)
          entity = create_entity(entity_type, merged_attributes, block)
          add_declaration(entity_type, domain, entity)
          add_identifier(name, entity)
        end

        def create_entity(type, attributes, block)
          creation_method = self.class.creation_method(type)
          __send__(creation_method, type, attributes, block)
        end

        def add_declaration(type, domain, entity)
          declaration_type = self.class.declaration_type(type)
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
end
