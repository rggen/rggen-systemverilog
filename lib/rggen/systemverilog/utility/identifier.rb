# frozen_string_literal: true

module RgGen
  module SystemVerilog
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

        def [](array_index_or_msb, lsb = nil)
          if array_index_or_msb
            __create_new_identifier__(array_index_or_msb, lsb)
          else
            self
          end
        end

        private

        def __create_new_identifier__(array_index_or_msb, lsb)
          select =
            if array_index_or_msb.is_a?(::Array)
              __array_select__(array_index_or_msb)
            elsif lsb.nil? || array_index_or_msb == lsb
              "[#{array_index_or_msb}]"
            else
              "[#{array_index_or_msb}:#{lsb}]"
            end
          Identifier.new("#{@name}#{select}") do |identifier|
            identifier.__sub_identifiers__(@sub_identifiers)
          end
        end

        def __array_select__(array_index)
          if @array_format == :vectorized
            "[#{__vecotr_lsb__(array_index)}+:#{@width}]"
          else
            array_index
              .map { |index| "[#{index}]" }
              .join
          end
        end

        def __vecotr_lsb__(array_index)
          __reduce_array__([@width, __vecotr_index__(array_index)], :*, 1)
        end

        def __vecotr_index__(array_index)
          index_values =
            array_index
              .reverse
              .zip(__index_factors__)
              .map { |i, f| __calc_index_value__(i, f) }
          index = __reduce_array__(index_values.reverse, :+, 0)
          integer?(index) ? index : "(#{index})"
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
