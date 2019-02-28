# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module CodeUtility
      class CodeBlock
        def initialize(indent = 0)
          @indent = indent
          @lines = []
          add_line
        end

        attr_reader :indent

        def <<(rhs)
          case rhs
          when String
            add_string(rhs)
          when CodeBlock
            merge_code_block(rhs)
          else
            add_word(rhs)
          end
          self
        end

        def indent=(indent)
          @indent = indent
          last_line.indent = indent
        end

        def last_line_empty?
          last_line.empty?
        end

        def to_s
          @lines.map(&:to_s).each(&:rstrip!).join(newline)
        end

        private

        def add_line(additional_indent = 0)
          line = Line.new(@indent + additional_indent)
          @lines << line
        end

        def add_string(rhs)
          lines =
            if rhs.include?(newline)
              (rhs + ((rhs.end_with?(newline) && newline) || '')).lines
            else
              [rhs]
            end
          lines.each_with_index do |line, i|
            i.zero? || add_line
            add_word(line.chomp)
          end
        end

        def merge_code_block(rhs)
          rhs.lines.each_with_index do |line, i|
            if i.zero?
              last_line_empty? && (last_line.indent += line.indent)
            else
              add_line((line.empty? && 0) || line.indent)
            end
            last_line.concat(line)
          end
        end

        def last_line
          @lines.last
        end

        def add_word(word)
          last_line << word
        end

        def newline
          "\n"
        end

        attr_reader :lines
        protected :lines
      end
    end
  end
end
