# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog
  describe Utility do
    let(:sv) do
      Class.new { include Utility }.new
    end

    describe '#create_blank_file' do
      it '空のソースファイルオブジェクトを生成する' do
        source_file = sv.create_blank_file('foo.sv')
        expect(source_file.to_code).to match_string('')

        source_file.include_guard
        expect(source_file.to_code).to match_string(<<~'CODE')
          `ifndef FOO_SV
          `define FOO_SV
          `endif
        CODE
      end
    end

    describe '#assign' do
      let(:lhs) { Utility::Identifier.new(:foo) }

      let(:rhs) do
        ['4\'b0000', Utility::Identifier.new(:bar)]
      end

      it '継続代入のコード片を返す' do
        expect(sv.send(:assign, lhs, rhs[0])).to eq 'assign foo = 4\'b0000;'
        expect(sv.send(:assign, lhs[0, 1], rhs[1])).to eq 'assign foo[0+:1] = bar;'
      end
    end

    describe '#concat' do
      let(:expressions) do
        [
          '4\'b0000',
          Utility::Identifier.new(:foo),
          Utility::Identifier.new(:bar)
        ]
      end

      it '連接のコード片を返す' do
        expect(sv.send(:concat, expressions)).to eq '{4\'b0000, foo, bar}'
        expect(sv.send(:concat, expressions[0])).to eq '{4\'b0000}'
      end
    end

    describe '#array' do
      let(:expressions) do
        [
          '4\'b0000',
          Utility::Identifier.new(:foo),
          Utility::Identifier.new(:bar)
        ]
      end

      it '配列リテラルのコード片を返す' do
        expect(sv.send(:array, expressions)).to eq '\'{4\'b0000, foo, bar}'
        expect(sv.send(:array, expressions[0])).to eq '\'{4\'b0000}'
        expect(sv.send(:array, [])).to eq '\'{}'
        expect(sv.send(:array, nil)).to eq '\'{}'
      end
    end

    describe '#bin' do
      it '与えた数のSystemVerilogの2進数表記を返す' do
        expect(sv.send(:bin, 2)).to eq '\'b10'
        expect(sv.send(:bin, 2, 1)).to eq '2\'b10'
        expect(sv.send(:bin, 2, 2)).to eq '2\'b10'
        expect(sv.send(:bin, 2, 3)).to eq '3\'b010'
      end
    end

    describe '#dec' do
      it '与えた数のSystemVerilogの10進数表記を返す' do
        expect(sv.send(:dec, 8)).to eq '\'d8'
        expect(sv.send(:dec, 8, 3)).to eq '4\'d8'
        expect(sv.send(:dec, 8, 4)).to eq '4\'d8'
        expect(sv.send(:dec, 8, 5)).to eq '5\'d8'
      end
    end

    describe '#hex' do
      it '与えた数のSystemVerilogの16進数表記を返す' do
        expect(sv.send(:hex, 0x10)).to eq '\'h10'
        expect(sv.send(:hex, 0x10, 4)).to eq '5\'h10'
        expect(sv.send(:hex, 0x10, 5)).to eq '5\'h10'
        expect(sv.send(:hex, 0x10, 8)).to eq '8\'h10'
        expect(sv.send(:hex, 0x10, 9)).to eq '9\'h010'
      end
    end
  end
end
