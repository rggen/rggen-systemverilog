# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module RTL
      module PartialSum
        private

        def partial_sums(operands)
          sums =
            operands
              .chunk(&method(:integer?))
              .flat_map(&method(:calc_partial_sum))
              .reject { |value| integer?(value) && value.zero? }
          sums.empty? && [0] || sums
        end

        def calc_partial_sum(kind_ans_values)
          kind, values = kind_ans_values
          kind && values.sum || values
        end

        def integer?(value)
          value.is_a?(Integer)
        end
      end
    end
  end
end
