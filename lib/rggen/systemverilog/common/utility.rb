# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        include Core::Utility::CodeUtility

        def create_blank_file(path)
          SourceFile.new(path)
        end

        private

        def create_identifier(name)
          Identifier.new(name)
        end

        def assign(lhs, rhs)
          "assign #{lhs} = #{rhs};"
        end

        def concat(expressions)
          "{#{Array(expressions).join(', ')}}"
        end

        def repeat(count, expression)
          "{#{count}{#{expression}}}"
        end

        def array(expressions = nil, default: nil)
          default_item = default && "default: #{default}"
          "'#{concat([*Array(expressions), default_item].compact)}"
        end

        def function_call(name, expressions = nil)
          "#{name}(#{Array(expressions).join(', ')})"
        end

        def macro_call(name, expressions = nil)
          if (expression_array = Array(expressions)).empty?
            "`#{name}"
          else
            "`#{name}(#{expression_array.join(', ')})"
          end
        end

        def bin(value, width = nil)
          if width
            width = bit_width(value, width)
            format("%d'b%0*b", width, width, value)
          else
            format("'b%b", value)
          end
        end

        def dec(value, width = nil)
          if width
            width = bit_width(value, width)
            format("%0d'd%d", width, value)
          else
            format("'d%d", value)
          end
        end

        def hex(value, width = nil)
          if width
            width = bit_width(value, width)
            print_width = (width + 3) / 4
            format("%0d'h%0*x", width, print_width, value)
          else
            format("'h%x", value)
          end
        end

        def bit_width(value, width)
          bit_length = value.bit_length
          bit_length = 1 if bit_length.zero?
          [width, bit_length].max
        end

        def argument(name, attribute = {})
          DataObject.new(:argument, attribute.merge(name: name)).declaration
        end

        {
          class_definition: ClassDefinition,
          function_definition: FunctionDefinition,
          local_scope: LocalScope,
          module_definition: ModuleDefinition,
          package_definition: PackageDefinition
        }.each do |method_name, definition|
          define_method(method_name) do |name, attributes = {}, &block|
            definition.new(attributes.merge(name: name), &block).to_code
          end
        end
      end
    end
  end
end
