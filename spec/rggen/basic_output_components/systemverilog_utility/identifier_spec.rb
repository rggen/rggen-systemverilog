# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::SystemVerilogUtility
  describe Identifier do
    let(:name) { :foo }

    let(:width) { 8 }

    let(:array_size) do
      [nil, [], [2, 3, 4]].sample
    end

    let(:array_format) do
      [nil, :packed, :unpacked, :vectorized].sample
    end

    let(:identifier) do
      Identifier.new(name, width, array_size, array_format)
    end

    def match_identifier(expectation)
      match_string(expectation)
    end

    describe '#[]' do
      context 'nilが与えられた場合' do
        it '自分自身を返す' do
          expect(identifier[nil]).to be identifier
        end
      end

      context 'ビット選択がされた場合' do
        let(:index) { rand(width - 1) }

        it 'ビット選択がされた識別子を返す' do
          expect(identifier[index]).to match_identifier("#{name}[#{index}]")
        end
      end

      context 'パート選択がされて' do
        context 'MSBとLSBが同値の場合' do
          let(:msb) { rand(width - 1) }

          let(:lsb) { msb }

          it 'ビット選択がされた識別子を返す' do
            expect(identifier[msb, lsb]).to match_identifier("#{name}[#{msb}]")
          end
        end

        context 'MSBとLSBが異なる場合' do
          let(:lsb) { rand(0..(width - 2) )}

          let(:msb) { rand((lsb + 1)..(width - 1)) }

          it 'パート選択された識別子を返す' do
            expect(identifier[msb, lsb]).to match_identifier("#{name}[#{msb}:#{lsb}]")
          end
        end
      end

      context '配列選択がされて' do
        let(:array_size) { [2, 3, 4] }

        let(:array_index) { [:i, :j, :k] }

        context '配列の形式がpackedの場合' do
          let(:array_format) { :packed }

          it '配列形式で選択された識別子を返す' do
            expect(identifier[array_index]).to match_identifier("#{name}[i][j][k]")
          end
        end

        context '配列の形式がunpackedの場合' do
          let(:array_format) { :unpacked }

          it '配列形式で選択された識別子を返す' do
            expect(identifier[array_index]).to match_identifier("#{name}[i][j][k]")
          end
        end

        context '配列の形式がvectorizedの場合' do
          let(:array_format) { :vectorized }

          it 'ベクトル形式で選択された識別子を返す' do
            expect(identifier[array_index]).to match_identifier("#{name}[#{width}*(12*i+4*j+k)+:#{width}]")
          end
        end
      end
    end

    describe '階層アクセス' do
      it '階層アクセスされた識別子を返す' do
        expect(identifier).to respond_to(:bar)
        expect(identifier.bar).to match_identifier('foo.bar')

        expect(identifier.bar).to respond_to(:baz)
        expect(identifier.bar.baz).to match_identifier('foo.bar.baz')
      end

      it '#to_s以外の型変換メソッドには反応しない' do
        [
          :to_a,
          :to_ary,
          :to_f,
          :to_h,
          :to_hash,
          :to_i,
          :to_int,
          :to_io,
          :to_proc,
          :to_regexp,
          :to_str
        ].each do |m|
          expect(identifier).not_to respond_to(m)
          expect {
            identifier.__send__(m)
          }.to raise_error NoMethodError
        end
      end

      it '__で囲まれた識別子には反応しない' do
        /\w*/.examples.each do |pattern|
          string = "__#{pattern}__"
          expect(identifier).not_to respond_to(string)
          expect {
            identifier.__send__(string)
          }.to raise_error NoMethodError
        end
      end
    end
  end
end
