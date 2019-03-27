# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog
  describe FeatureRTL do
    let(:configuration) do
      RgGen::Core::Configuration::Component.new(nil)
    end

    let(:register_map) do
      RgGen::Core::RegisterMap::Component.new(nil, configuration)
    end

    let(:component) do
      RgGen::Core::OutputBase::Component.new(nil, configuration, register_map)
    end

    let(:feature) do
      FeatureRTL.new(component, :foo) do |f|
        component.add_feature(f)
      end
    end

    describe '#logic' do
      specify 'ハンドル名で、定義した変数の識別子を参照できる' do
        feature.send(:logic, :domain_a, :foo)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:logic, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        expect(feature.baz).to match_identifier('bazbaz')
      end

      specify '定義した変数の識別子はコンポーネント経由で参照できる' do
        feature.send(:logic, :domain_a, :foo)
        feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:logic, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('barbar')
        expect(component.baz).to match_identifier('bazbaz')
      end

      specify '定義した変数の宣言は#declarationsで参照できる' do
        feature.send(:logic, :domain_a, :foo)
        feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:logic, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }

        expect(feature.declarations(:domain_a, :variable)).to match([
          match_declaration('logic foo'),
          match_declaration('logic [1:0][1:0] barbar')
        ])
        expect(feature.declarations(:domain_b, :variable)).to match([
          match_declaration('logic [1:0][1:0] bazbaz')
        ])
      end
    end

    describe '#interface' do
      specify 'ハンドル名で、定義したインターフェースの識別子を参照できる' do
        feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:interface, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          parameter_values [1, 2]
          variables [:baz_0, :baz_1]
        }
        expect(feature.baz).to match_identifier('bazbaz')
        expect(feature.baz.baz_0).to match_identifier('bazbaz.baz_0')
        expect(feature.baz.baz_1).to match_identifier('bazbaz.baz_1')
      end

      specify '定義したインターフェースの識別子はコンポーネント経由で参照できる' do
        feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
        feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
        feature.send(:interface, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          parameter_values [1, 2]
          variables [:baz_0, :baz_1]
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('barbar')
        expect(component.baz).to match_identifier('bazbaz')
        expect(component.baz.baz_0).to match_identifier('bazbaz.baz_0')
        expect(component.baz.baz_1).to match_identifier('bazbaz.baz_1')
      end

      specify '定義したインターフェースの宣言は#declarationsで参照できる' do
        feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
        feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
        feature.send(:interface, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          parameter_values [1, 2]
          variables [:baz_0, :baz_1]
        }

        expect(feature.declarations(:domain_a, :variable)).to match([
          match_declaration('foo_if foo()'),
          match_declaration('bar_if barbar[2]()')
        ])
        expect(feature.declarations(:domain_b, :variable)).to match([
          match_declaration('baz_if #(1, 2) bazbaz()')
        ])
      end
    end

    describe '#input' do
      specify 'ハンドル名で、定義した入力ポートの識別子を参照できる' do
        feature.send(:input, :domain_a, :foo)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:input, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        expect(feature.baz).to match_identifier('bazbaz')
      end

      specify '定義した入力ポートの識別子はコンポーネント経由で参照できる' do
        feature.send(:input, :domain_a, :foo)
        feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:input, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('barbar')
        expect(component.baz).to match_identifier('bazbaz')
      end

      specify '定義した入力ポートの宣言は#declarationsで参照できる' do
        feature.send(:input, :domain_a, :foo)
        feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:input, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }

        expect(feature.declarations(:domain_a, :port)).to match([
          match_declaration('input foo'),
          match_declaration('input [1:0][1:0] barbar')
        ])
        expect(feature.declarations(:domain_b, :port)).to match([
          match_declaration('input [1:0][1:0] bazbaz')
        ])
      end
    end

    describe '#output' do
      specify 'ハンドル名で、定義した出力ポートの識別子を参照できる' do
        feature.send(:output, :domain_a, :foo)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:output, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        expect(feature.baz).to match_identifier('bazbaz')
      end

      specify '定義した出力ポートの識別子はコンポーネント経由で参照できる' do
        feature.send(:output, :domain_a, :foo)
        feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:output, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('barbar')
        expect(component.baz).to match_identifier('bazbaz')
      end

      specify '定義した出力ポートの宣言は#declarationsで参照できる' do
        feature.send(:output, :domain_a, :foo)
        feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
        feature.send(:output, :domain_b, :baz) {
          name 'bazbaz'
          width 2
          array_size [2]
        }

        expect(feature.declarations(:domain_a, :port)).to match([
          match_declaration('output foo'),
          match_declaration('output [1:0][1:0] barbar')
        ])
        expect(feature.declarations(:domain_b, :port)).to match([
          match_declaration('output [1:0][1:0] bazbaz')
        ])
      end
    end

    describe '#interface_port' do
      specify 'ハンドル名で、定義したインターフェースポートの識別子を参照できる' do
        feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:interface_port, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          modport :baz, [:baz_0, :baz_1]
          array_size [2]
        }
        expect(feature.baz).to match_identifier('bazbaz')
        expect(feature.baz.baz_0).to match_identifier('bazbaz.baz_0')
        expect(feature.baz.baz_1).to match_identifier('bazbaz.baz_1')
      end

      specify '定義したインターフェースポートの識別子はコンポーネント経由で参照できる' do
        feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
        feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
        feature.send(:interface_port, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          modport :baz, [:baz_0, :baz_1]
          array_size [2]
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('barbar')
        expect(component.baz).to match_identifier('bazbaz')
        expect(component.baz.baz_0).to match_identifier('bazbaz.baz_0')
        expect(component.baz.baz_1).to match_identifier('bazbaz.baz_1')
      end

      specify '定義したインターフェースポートの宣言は#declarationsで参照できる' do
        feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
        feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
        feature.send(:interface_port, :domain_b, :baz) {
          interface_type :baz_if
          name 'bazbaz'
          modport :baz, [:baz_0, :baz_1]
          array_size [2]
        }

        expect(feature.declarations(:domain_a, :port)).to match([
          match_declaration('foo_if foo'),
          match_declaration('bar_if.bar barbar[2]')
        ])
        expect(feature.declarations(:domain_b, :port)).to match([
          match_declaration('baz_if.baz bazbaz[2]')
        ])
      end
    end

    describe '#parameter' do
      specify 'ハンドル名で、定義したパラメータの識別子を参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        expect(feature.bar).to match_identifier('BAR')

        feature.send(:parameter, :domain_b, :baz) {
          name 'BAZ'
          data_type :int
          default 3
        }
        expect(feature.baz).to match_identifier('BAZ')
      end

      specify '定義したパラメータの識別子はコンポーネント経由で参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        feature.send(:parameter, :domain_b, :baz) {
          name 'BAZ'
          data_type :int
          default 3
        }
        component.build

        expect(component.foo).to match_identifier('foo')
        expect(component.bar).to match_identifier('BAR')
        expect(component.baz).to match_identifier('BAZ')
      end

      specify '定義したパラメータの宣言は#declarationsで参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        feature.send(:parameter, :domain_b, :baz) {
          name 'BAZ'
          data_type :int
          default 3
        }

        expect(feature.declarations(:domain_a, :parameter)).to match([
          match_declaration('parameter foo = 1'),
          match_declaration('parameter int BAR = 2')
        ])
        expect(feature.declarations(:domain_b, :parameter)).to match([
          match_declaration('parameter int BAZ = 3')
        ])
      end
    end
  end
end
