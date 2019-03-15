# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilogUtility
      class Identifier < BasicObject
        def initialize(name, width = nil, size = nil, format = nil)
          @name = name
          @width = width
          @array_size = size
          @array_format = format
        end

        def to_s
          @name
        end

        def [](array_index_or_msb, lsb = nil)
          if array_index_or_msb
            __create_new_identifier__(array_index_or_msb, lsb)
          else
            self
          end
        end

        TYPE_CONVERSIONS = [
          :to_a,
          :to_ary,
          :to_f,
          :to_enum,
          :to_h,
          :to_hash,
          :to_i,
          :to_int,
          :to_io,
          :to_proc,
          :to_regexp,
          :to_str
        ].freeze

        def respond_to?(name, _include_all = false)
          return false if TYPE_CONVERSIONS.include?(name.to_sym)
          return false if /\A__.*__\z/ =~ name
          true
        end

        private

        def method_missing(name, *_args)
          return super unless respond_to?(name)
          Identifier.new("#{@name}.#{name}")
        end

        def __create_new_identifier__(array_index_or_msb, lsb)
          select =
            if array_index_or_msb.is_a?(::Array)
              __array_select__(array_index_or_msb)
            elsif lsb.nil? || array_index_or_msb == lsb
              "[#{array_index_or_msb}]"
            else
              "[#{array_index_or_msb}:#{lsb}]"
            end
          Identifier.new("#{@name}#{select}")
        end

        def __array_select__(array_index)
          if @array_format == :vectorized
            "[#{@width}*(#{__vecotr_index__(array_index)})+:#{@width}]"
          else
            array_index
              .map { |index| "[#{index}]" }
              .join
          end
        end

        def __vecotr_index__(array_index)
          index = []
          array_index.zip(__index_factors__).reverse_each do |i, f|
            index.unshift((index.size.zero? && i.to_s) || "#{f}*#{i}")
          end
          index.join('+')
        end

        def __index_factors__
          factors = []
          @array_size.reverse_each.inject(1) do |elements, size|
            factors.unshift(elements)
            elements * size
          end
          factors
        end
      end
    end
  end
end
