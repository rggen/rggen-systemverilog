# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::CodeUtility
  describe Line do
    let(:line) { Line.new }

    describe '#<<' do
      it '右辺値を単語を追加する' do
        line << 'foo'
        expect(line.to_s).to eq 'foo'
      end

      it '連続で単語を追加することができる' do
        line << 'foo' << 'bar'
        expect(line.to_s).to eq 'foobar'
      end
    end

    describe '#empty?' do
      context '単語の追加がない場合' do
        specify 'その行は空行である' do
          expect(line).to be_empty
        end
      end

      context '空文字(nil/#empty?がtrueを返す)が追加されている場合' do
        specify 'その行は空行である' do
          ['', [], nil, Line.new].shuffle.each { |word| line << word }
          expect(line).to be_empty
        end
      end

      context '単語(#emptyがfalseを返す/#empty?が実装されていない)が追加されている場合' do
        specify 'その行は空行ではない' do
          [' ', 'foo', :foo, 0, false, (Line.new << 'bar')].shuffle.each { |word| line << word }
          expect(line).not_to be_empty
        end
      end
    end

    describe '#to_s' do
      context '#indent=でインデント幅の指定がある場合' do
        let(:indent_size) { [2, 4, 8].sample }

        it '行頭に指定された幅の空白を追加して、文字列を出力する' do
          line << 'foo'
          line.indent = indent_size
          expect(line.to_s).to eq "#{' ' * indent_size}foo"
        end
      end
    end
  end
end
