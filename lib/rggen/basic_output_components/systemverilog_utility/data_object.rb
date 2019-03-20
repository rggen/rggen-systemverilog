# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class DataObject
        include Core::Utility::AttributeSetter

        def initialize(object_type, **default_attributes, &block)
          @object_type = object_type
          apply_attributes(default_attributes)
          block_given? && Docile.dsl_eval(self, &block)
        end

        define_attribute :name
        define_attribute :direction
        define_attribute :parameter_type
        define_attribute :data_type
        define_attribute :width
        define_attribute :array_size
        define_attribute :array_format, :packed
        define_attribute :random
        define_attribute :default

        def declaration
          declaration_snippets
            .select(&:itself)
            .reject(&:empty?)
            .join(' ')
        end

        def identifier
          Identifier.new(name) do |identifier|
            identifier.__width__(width)
            identifier.__array_size__(array_size)
            identifier.__array_format__(array_format)
          end
        end

        private

        def declaration_snippets
          [
            rand_keyword,
            artument_direction,
            paraemter_keyword,
            data_type,
            packed_dimensions,
            object_identifier,
            default_value
          ]
        end

        def rand_keyword
          @object_type == :variable && random
        end

        def artument_direction
          @object_type == :argument && direction
        end

        def paraemter_keyword
          @object_type == :parameter && parameter_type
        end

        def packed_dimensions
          (vectorized_array? ? vectorized_array_size : packed_array_size)
            .map { |size| "[#{msb(size)}:0]" }
            .join
        end

        def msb(size)
          (size.is_a?(Integer) && size - 1) || "#{size}-1"
        end

        def array?
          return false unless array_size
          !array_size.empty?
        end

        def vectorized_array?
          array? && array_format == :vectorized
        end

        def vectorized_array_size
          size = [(width || 1), *array_size]
          if size.all? { |s| s.is_a?(Integer) }
            [size.inject(&:*)]
          else
            [size.join('*')]
          end
        end

        def packed_array_size
          size = []
          size.concat(Array(array_size)) if array_format == :packed
          size << width if valid_width?
          size
        end

        def valid_width?
          return false unless width
          return true unless width.is_a?(Integer)
          width > 1
        end

        def object_identifier
          "#{name}#{unpacked_dimensions}"
        end

        def unpacked_array?
          array? && array_format == :unpacked
        end

        def unpacked_dimensions
          return unless unpacked_array?
          array_size.map { |size| "[#{size}]" }.join
        end

        def default_value
          default && "= #{default}"
        end
      end
    end
  end
end
