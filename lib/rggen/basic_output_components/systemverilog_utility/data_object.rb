# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class DataObject
        class << self
          def attributes
            @attributes ||= []
          end

          private

          def define_attribute(name)
            attributes << name
            attr_setter(name)
          end
        end

        def initialize(object_type, **default_attributes, &block)
          @object_type = object_type
          @array_format = :packed
          apply_default_attributes(default_attributes)
          block_given? && Docile.dsl_eval(self, &block)
        end

        define_attribute :name
        define_attribute :direction
        define_attribute :parameter_type
        define_attribute :data_type
        define_attribute :width
        define_attribute :array_size
        define_attribute :array_format
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
            identifier.__array_attributes__(width, array_size, array_format)
          end
        end

        private

        def apply_default_attributes(default_attributes)
          default_attributes.each do |name, value|
            self.class.attributes.include?(name) && __send__(name, value)
          end
        end

        def declaration_snippets
          [
            rand_keyword,
            artument_direction,
            paraemter_keyword,
            data_type,
            packed_dimensions,
            data_identifier,
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
            .map { |size| (size.is_a?(Integer) && size - 1) || "#{size}-1" }
            .map { |msb| "[#{msb}:0]" }
            .join
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

        def data_identifier
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
