module RgGen
  module BasicOutputComponents
    module CodeUtility
      class Line
        def initialize
          @words = []
        end

        attr_accessor :indent

        def <<(word)
          @words << word
          self
        end

        def empty?
          @words.all?(&method(:empty_word?))
        end

        def to_s
          [' ' * (@indent || 0), *@words].join
        end

        private

        def empty_word?(word)
          return true if word.nil?
          return false unless word.respond_to?(:empty?)
          word.empty?
        end
      end
    end
  end
end
