# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe InterfacePort do
    def interface_port(interface_type, name, &block)
      InterfacePort.new(interface_type: interface_type, name: name, &block)
    end

    describe '#declaration' do
      it 'インターフェースポートの宣言を返す' do
        expect(interface_port(:foo_if, :foo)).to match_declaration('foo_if foo')
        expect(interface_port(:foo_if, :foo) { |i| i.modport :slave }).to match_declaration('foo_if.slave foo')
        expect(interface_port(:foo_if, :foo) { |i| i.modport :slave, [:bar, :baz] }).to match_declaration('foo_if.slave foo')
        expect(interface_port(:foo_if, :foo) { |i| i.array_size [2, 3] }).to match_declaration('foo_if foo[2][3]')
        expect(interface_port(:foo_if, :foo) { |i| i.modport :slave, [:bar, :baz]; i.array_size [2, 3] }).to match_declaration('foo_if.slave foo[2][3]')
      end
    end

    describe '#identifier' do
      it '識別子を返す' do
        expect(interface_port(:foo_if, :foo)).to match_identifier('foo')
        expect(interface_port(:foo_if, :foo) { |i| i. modport :slave }).to match_identifier('foo')
        expect(interface_port(:foo_if, :foo) { |i| i. array_size [2, 3] }).to match_identifier('foo')
        expect(interface_port(:foo_if, :foo) { |i| i. array_size [2, 3] }.identifier[[1, 2]]).to match_identifier('foo[1][2]')
      end

      context '#modportで下位ポートが設定された場合' do
        specify '下位ポートの識別子を取得できる' do
          identifier = interface_port(:foo_if, :foo) { |i| i.modport :slave, [:bar, :baz] }.identifier
          expect(identifier.bar).to match_identifier('foo.bar')
          expect(identifier.baz).to match_identifier('foo.baz')

          identifier = interface_port(:foo_if, :foo) {  |i| i.modport :slave, [:bar, :baz]; i.array_size [2, 3] }.identifier
          expect(identifier[1][2].bar).to match_identifier('foo[1][2].bar')
          expect(identifier[1][2].baz).to match_identifier('foo[1][2].baz')
          expect(identifier[[1, 2]].bar).to match_identifier('foo[1][2].bar')
          expect(identifier[[1, 2]].baz).to match_identifier('foo[1][2].baz')
        end
      end
    end
  end
end
