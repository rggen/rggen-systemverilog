# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      class Feature < Core::OutputBase::Feature
        include Common::Utility
        template_engine Core::OutputBase::ERBEngine

        EntityContext =
          Struct.new(:entity_type, :method_name, :declaration_type, :default_layer)

        class << self
          private

          def define_entity(entity_type, method, declaration_type, default_layer)
            context =
              EntityContext.new(entity_type, method, declaration_type, default_layer)
            feature_hash_variable_store(:@entity_contexts, entity_type, context)

            return if method_defined?(entity_type)
            public alias_method(entity_type, :entity_method)
          end
        end

        def package_imports(domain)
          @package_imports[domain]
        end

        private

        def post_initialize
          super
          @package_imports = Hash.new { |h, k| h[k] = [] }
        end

        def entity_method(name, *args, &)
          if args.size >= 3
            message = 'wrong number of arguments ' \
                      "(given #{args.size + 1}, expected 1..3)"
            raise ArgumentError.new(message)
          end

          context = feature_hash_variable_fetch(:@entity_contexts, __callee__)
          define_entity(context, name, args, &)
        end

        def define_entity(context, name, args, &)
          layer, attributes = parse_entity_arguments(args)
          entity = create_entity(context, name, attributes, &)
          add_entity(context, entity, name, layer)
        end

        def parse_entity_arguments(args)
          if args.empty?
            [nil, nil]
          elsif args.size == 1 && args.first.is_a?(Hash)
            [nil, args.first]
          elsif args.size == 1
            [args.first, nil]
          else
            args[0..1]
          end
        end

        def create_entity(context, name, attributes, &)
          merged_attributes = { name: }.merge(Hash(attributes))
          __send__(context.method_name, context.entity_type, merged_attributes, &)
        end

        def add_entity(context, entity, name, layer)
          add_declaration(context, entity, layer)
          add_identifier(entity, name)
        end

        def add_declaration(context, entity, layer)
          (layer || instance_exec(&context.default_layer))
            .declarations[context.declaration_type] << entity.declaration
        end

        def add_identifier(entity, name)
          instance_variable_set("@#{name}", entity.identifier)
          singleton_exec { attr_reader name }
          export(name)
        end

        def import_package(domain, package)
          @package_imports[domain].include?(package) ||
            (@package_imports[domain] << package)
        end

        def import_packages(domain, packages)
          Array(packages).each { |package| import_package(domain, package) }
        end
      end
    end
  end
end
