# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe InterfaceInstance do
    def interface_instance(interface_type, name, &block)
      InterfaceInstance.new(interface_type: interface_type, name: name, &block)
    end

    describe '#instantiation' do
      it 'インターフェースのインスタンス記述を返す' do
        expect(
          interface_instance(:foo_if, :foo).instantiation
        ).to match_string('foo_if foo()')

        expect(
          interface_instance(:foo_if, :foo) { |i|
            i.parameter_values [:BAR, :BAZ]
          }.instantiation
        ).to match_string('foo_if #(BAR, BAZ) foo()')

        expect(
          interface_instance(:foo_if, :foo) { |i|
            i.port_connections [:bar, :baz]
          }.instantiation
        ).to match_string('foo_if foo(bar, baz)')

        expect(
          interface_instance(:foo_if, :foo) { |i|
            i.array_size [2, 3]
          }.instantiation
        ).to match_string('foo_if foo[2][3]()')

        expect(
          interface_instance(:foo_if, :foo) { |i|
            i.parameter_values [:BAR, :BAZ]
            i.port_connections [:bar, :baz]
            i.array_size [2, 3]
          }.instantiation
        ).to match_string('foo_if #(BAR, BAZ) foo[2][3](bar, baz)')
      end
    end

    describe '#identifier' do
      it 'インスタンスの識別子を返す' do
        expect(interface_instance(:foo_if, :foo)).to match_identifier('foo')
        expect(interface_instance(:foo_if, :foo) { |i| i.parameter_values [:BAR, :BAZ] }).to match_identifier('foo')
        expect(interface_instance(:foo_if, :foo) { |i| i.port_connections [:bar, :baz] }).to match_identifier('foo')
        expect(interface_instance(:foo_if, :foo) { |i| i.array_size [2, 3] }).to match_identifier('foo')
        expect(interface_instance(:foo_if, :foo) { |i| i.array_size [2, 3] }.identifier[[1, 2]]).to match_identifier('foo[1][2]')
      end

      context '#variablesで下位変数が設定されている場合' do
        specify '下位変数の識別子を取得できる' do
          identifier = interface_instance(:foo_if, :foo) { |i| i.variables [:bar, :baz] }.identifier
          expect(identifier.bar).to match_identifier('foo.bar')
          expect(identifier.baz).to match_identifier('foo.baz')

          identifier = interface_instance(:foo_if, :foo) { |i| i.variables [:bar, :baz]; i.array_size [2, 3] }.identifier
          expect(identifier[1][2].bar).to match_identifier('foo[1][2].bar')
          expect(identifier[1][2].baz).to match_identifier('foo[1][2].baz')
        end
      end
    end
  end
end
