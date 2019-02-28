# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents
  describe CodeUtility do
    let(:utility) do
      object = Object.new
      object.extend(CodeUtility)
      object
    end

    describe '#create_blank_code' do
      it '空のCodeBlockオブジェクトを返す' do
        code_block = utility.create_blank_code
        expect(code_block).to be_instance_of CodeUtility::CodeBlock
        expect(code_block.to_s).to be_empty
      end
    end

    describe '#newline/#nl' do
      it '改行文字を返す' do
        expect(utility.send(:newline)).to eq "\n"
        expect(utility.send(:nl)).to eq "\n"
      end
    end

    describe '#comma' do
      it 'コンマを返す' do
        expect(utility.send(:comma)).to eq ','
      end
    end

    describe '#colon' do
      it 'コロンを返す' do
        expect(utility.send(:colon)).to eq ':'
      end
    end

    describe '#semicolon' do
      it 'セミコロンを返す' do
        expect(utility.send(:semicolon)).to eq ';'
      end
    end

    describe '#space' do
      context '無引数の場合' do
        it 'スペースを１つ返す' do
          expect(utility.send(:space)).to eq ' '
        end
      end

      context '引数で幅が指定された場合' do
        it '指定された幅のスペースを返す' do
          expect(utility.send(:space, 1)).to eq ' '
          expect(utility.send(:space, 2)).to eq '  '
          expect(utility.send(:space, 3)).to eq '   '
        end
      end
    end

    describe '#string' do
      it '文字列リテラルを返す' do
        bar= Object.new
        def bar.to_s; 'bar'; end
        expect(utility.send(:string, 'foo')).to eq '"foo"'
        expect(utility.send(:string, :foo)).to eq '"foo"'
        expect(utility.send(:string, 1)).to eq '"1"'
        expect(utility.send(:string, bar)).to eq '"bar"'
      end
    end

    describe '#code_block' do
      it 'CodeBlockオブジェクトを返す' do
        expect(utility.send(:code_block)).to be_instance_of(CodeUtility::CodeBlock)
      end

      it 'インデント幅を指定できる' do
        code_block = utility.send(:code_block, 2)
        code_block << :foo
        expect(code_block.to_s).to eq '  foo'
      end

      it 'CodeBlockオブジェクトを引数にして、ブロックを実行できる' do
        code_block = utility.send(:code_block) { |c| c << 'foo' }
        expect(code_block.to_s).to eq 'foo'
      end
    end

    describe '#indent' do
      let(:code_block) { CodeUtility::CodeBlock.new(2) }

      it 'ブロック内で追加した行に、指定したインデントを付加する' do
        code_block << 'foo' << "\n"
        utility.send(:indent, code_block, 2) do
          code_block << 'bar' << "\n"
        end
        code_block << 'baz'
        expect(code_block.to_s).to eq "  foo\n    bar\n  baz"
      end

      context 'インデント設定前の末尾の行が空行ではない場合' do
        it '改行を挿入してから、インデントを設定する' do
          code_block << 'foo'
          utility.send(:indent, code_block, 2) do
            code_block << 'bar' << "\n"
          end
          expect(code_block.to_s).to eq "  foo\n    bar\n"
        end
      end

      context 'インデント設定後の末尾の行が空行ではない場合' do
        it '改行を挿入してから、インデントの設定を戻す' do
          utility.send(:indent, code_block, 2) do
            code_block << 'bar'
          end
          code_block << 'baz'
          expect(code_block.to_s).to eq "    bar\n  baz"
        end
      end
    end

    describe '#wrap' do
      it 'ブロック内で追加したコードを、head/tailで指定した文字列で囲む' do
        code_block = CodeUtility::CodeBlock.new
        utility.send(:wrap, code_block, '(', ')') do
          code_block << 'foo'
          code_block << 'bar'
        end
        expect(code_block.to_s).to eq '(foobar)'
      end
    end

    describe '#loop_index' do
      it 'ネストの深さに応じたループ変数の識別子を返す' do
        expect(utility.send(:loop_index)).to eq 'i'
        expect(utility.send(:loop_index, 0)).to eq ''
        expect(utility.send(:loop_index, 1)).to eq 'i'
        expect(utility.send(:loop_index, 2)).to eq 'j'
        expect(utility.send(:loop_index, 3)).to eq 'k'
        expect(utility.send(:loop_index, 4)).to eq 'l'
      end
    end
  end
end
