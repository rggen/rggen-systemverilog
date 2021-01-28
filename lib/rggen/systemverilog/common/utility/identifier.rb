# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      module Utility
        class Identifier
          def initialize(name)
            @name = name
            block_given? && yield(self)
          end

          def __width__(width)
            @width = width
          end

          def __array_size__(array_size)
            @array_size = array_size
          end

          def __array_format__(array_format)
            @array_format = array_format
          end

          def __sub_identifiers__(sub_identifiers)
            Array(sub_identifiers).each do |sub_identifier|
              (@sub_identifiers ||= []) << sub_identifier
              define_singleton_method(sub_identifier) do
                Identifier.new("#{@name}.#{__method__}")
              end
            end
          end

          def to_s
            @name.to_s
          end

          def [](array_index_or_lsb, lsb_or_width = nil, width = nil)
            if array_index_or_lsb
              __create_new_identifier__(array_index_or_lsb, lsb_or_width, width)
            else
              self
            end
          end

          private

          def __create_new_identifier__(array_index_or_lsb, lsb_or_width, width)
            select = __create_select__(array_index_or_lsb, lsb_or_width, width)
            Identifier.new("#{@name}#{select}") do |identifier|
              identifier.__sub_identifiers__(@sub_identifiers)
            end
          end

          def __create_select__(array_index_or_lsb, lsb_or_width, width)
            if array_index_or_lsb.is_a?(::Array)
              __array_select__(array_index_or_lsb, lsb_or_width, width)
            elsif lsb_or_width
              "[#{array_index_or_lsb}+:#{lsb_or_width}]"
            else
              "[#{array_index_or_lsb}]"
            end
          end

          def __array_select__(array_index, lsb, width)
            if @array_format == :serialized
              "[#{__serialized_lsb__(array_index, lsb)}+:#{width || @width}]"
            else
              [
                *array_index.map { |index| "[#{index}]" },
                lsb && __create_select__(lsb, width, nil)
              ].compact.join
            end
          end

          def __serialized_lsb__(array_index, lsb)
            serialized_index = __serialized_index__(array_index)
            array_lsb = __reduce_array__([@width, serialized_index], :*, 1)
            __reduce_array__([array_lsb, lsb], :+, 0)
          end

          def __serialized_index__(array_index)
            array_index
              .reverse
              .zip(__index_factors__)
              .map { |i, f| __calc_index_value__(i, f) }
              .yield_self { |values| __reduce_array__(values.reverse, :+, 0) }
              .yield_self { |index| integer?(index) && index || "(#{index})" }
          end

          def __index_factors__
            Array.new(@array_size.size) do |i|
              i.zero? ? nil : __reduce_array__(@array_size[-i..-1], :*, 1)
            end
          end

          def __calc_index_value__(index, factor)
            __reduce_array__([factor, index].compact, :*, 1)
          end

          def __reduce_array__(array, operator, initial_value)
            array = array.compact
            if array.all?(&method(:integer?))
              array.reduce(initial_value, &operator)
            else
              array.join(operator.to_s)
            end
          end

          def integer?(value)
            value.is_a?(Integer)
          end
        end
      end
    end
  end
end
