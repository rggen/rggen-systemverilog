# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Utility do
  let(:sv) do
    Class.new { include RgGen::SystemVerilog::Common::Utility }.new
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

  describe '#create_identifier' do
    it '識別子オブジェクトを生成する' do
      expect(sv.send(:create_identifier, 'foo')).to match_identifier('foo')
    end
  end

  describe '#assign' do
    let(:lhs) { RgGen::SystemVerilog::Common::Utility::Identifier.new(:foo) }

    let(:rhs) do
      ['4\'b0000', RgGen::SystemVerilog::Common::Utility::Identifier.new(:bar)]
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
        RgGen::SystemVerilog::Common::Utility::Identifier.new(:foo),
        RgGen::SystemVerilog::Common::Utility::Identifier.new(:bar)
      ]
    end

    it '連接のコード片を返す' do
      expect(sv.send(:concat, expressions)).to eq '{4\'b0000, foo, bar}'
      expect(sv.send(:concat, expressions[0])).to eq '{4\'b0000}'
    end
  end

  describe '#repeat' do
    it '繰り返し連接のコード片を返す' do
      expect(sv.send(:repeat, 2, '4\'b0000')).to eq '{2{4\'b0000}}'
    end
  end

  describe '#array' do
    let(:expressions) do
      [
        '4\'b0000',
        RgGen::SystemVerilog::Common::Utility::Identifier.new(:foo),
        RgGen::SystemVerilog::Common::Utility::Identifier.new(:bar)
      ]
    end

    let(:default) { '4\'b1111' }

    it '配列リテラルのコード片を返す' do
      expect(sv.send(:array, expressions)).to eq '\'{4\'b0000, foo, bar}'
      expect(sv.send(:array, expressions, default: default)).to eq '\'{4\'b0000, foo, bar, default: 4\'b1111}'
      expect(sv.send(:array, expressions[0])).to eq '\'{4\'b0000}'
      expect(sv.send(:array, expressions[0], default: default)).to eq '\'{4\'b0000, default: 4\'b1111}'
      expect(sv.send(:array, [])).to eq '\'{}'
      expect(sv.send(:array, [], default: default)).to eq '\'{default: 4\'b1111}'
      expect(sv.send(:array, nil)).to eq '\'{}'
      expect(sv.send(:array, nil, default: default)).to eq '\'{default: 4\'b1111}'
      expect(sv.send(:array, default: default)).to eq '\'{default: 4\'b1111}'
    end
  end

  describe '#function_call' do
    it '関数呼び出しのコード片を返す' do
      expect(sv.send(:function_call, :foo)).to eq 'foo()'
      expect(sv.send(:function_call, :foo, :bar)).to eq 'foo(bar)'
      expect(sv.send(:function_call, :foo, [:bar, :baz])).to eq 'foo(bar, baz)'
    end
  end

  describe '#macro_call' do
    it '関数呼び出しのコード片を返す' do
      expect(sv.send(:macro_call, :foo)).to eq '`foo'
      expect(sv.send(:macro_call, :foo, :bar)).to eq '`foo(bar)'
      expect(sv.send(:macro_call, :foo, [:bar, :baz])).to eq '`foo(bar, baz)'
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

  describe 'width_cast' do
    it '幅キャストを行うコード片を返す' do
      expect(sv.send(:width_cast, '4*i', 8)).to eq '8\'(4*i)'
    end
  end
end
