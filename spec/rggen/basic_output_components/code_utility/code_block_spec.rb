# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::CodeUtility
  describe CodeBlock do
    let(:code_block) { CodeBlock.new }

    describe '#<<' do
      context '単語を追加する場合' do
        it '末尾に追加する' do
          code_block << 'foo'
          expect(code_block.to_s).to eq 'foo'
          code_block << 'bar'
          expect(code_block.to_s).to eq 'foobar'
          code_block << "\n"
          code_block << :baz
          expect(code_block.to_s).to eq "foobar\nbaz"
        end
      end

      context '複数行の文字列を追加する場合' do
        it '行ごとに追加する' do
          code_block << 'foo'
          code_block << <<~TEXT
          bar
             baz


          foobar
          TEXT

          expect(code_block.to_s).to eq <<~TEXT
            foobar
               baz


            foobar
          TEXT
        end
      end

      context 'CodeBlockオブジェクトを追加する場合' do
        specify '追加される行は、追加されるCodeBlockオブジェクトのインデントが付加される' do
          other_block = CodeBlock.new(2)
          other_block << "other_foo\nother_bar\n"
          code_block = CodeBlock.new
          code_block << "foo\n"
          code_block << other_block
          code_block << 'bar'
          expect(code_block.to_s).to eq "foo\n  other_foo\n  other_bar\nbar"

          other_block = CodeBlock.new(2)
          other_block << "other_foo\nother_bar\n"
          code_block = CodeBlock.new
          code_block << 'foo '
          code_block << other_block
          code_block << 'bar'
          expect(code_block.to_s).to eq "foo other_foo\n  other_bar\nbar"

          other_block = CodeBlock.new(2)
          other_block << "other_foo\nother_bar"
          code_block = CodeBlock.new
          code_block << "foo\n"
          code_block << other_block
          code_block << " bar\nbaz"
          expect(code_block.to_s).to eq "foo\n  other_foo\n  other_bar bar\nbaz"
        end
      end

      it '連続で追加できる' do
        other_block = CodeBlock.new
        other_block << 'bar'
        code_block << 'foo' << other_block<< 'baz'
        expect(code_block.to_s).to eq 'foobarbaz'
      end
    end

    describe '#indent=' do
      specify '末尾の行から、指定されたインデントが有効になる' do
        code_block << 'foo' << "\n"
        code_block << 'bar'
        code_block.indent += 2
        code_block << "\n" << 'baz'
        code_block.indent += 2
        code_block << "\n"
        code_block.indent -= 4
        code_block << 'foobar'
        expect(code_block.to_s).to eq "foo\n  bar\n    baz\nfoobar"
      end
    end

    describe '#to_s' do
      it '行末の空白文字を取り除く' do
        code_block << 'foo  ' << "\n"
        code_block << '     ' << "\n"
        code_block << '  bar' << "\t"
        expect(code_block.to_s).to eq "foo\n\n  bar"
      end
    end
  end
end
