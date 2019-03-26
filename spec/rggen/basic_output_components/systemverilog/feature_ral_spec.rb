# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::SystemVerilog
  describe FeatureRAL do
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
      FeatureRAL.new(component, :foo) do |f|
        component.add_feature(f)
      end
    end

    describe '#variable' do
      specify 'ハンドル名で、定義した変数の識別子を参照できる' do
        feature.send(:variable, :domain_a, :foo, data_type: :bit)
        expect(feature.foo).to match_identifier('foo')

        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: :rand)
        expect(feature.bar).to match_identifier('barbar')

        feature.send(:variable, :domain_b, :baz) {
          data_type :bit
          name 'bazbaz'
          width 2
          array_size [2]
        }
        expect(feature.baz).to match_identifier('bazbaz')
      end

      specify '定義した変数の識別子はコンポーネント経由で参照できる' do
        feature.send(:variable, :domain_a, :foo, data_type: :bit)
        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: true)
        feature.send(:variable, :domain_b, :baz) {
          data_type :bit
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
        feature.send(:variable, :domain_a, :foo, data_type: :bit)
        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: true)
        feature.send(:variable, :domain_b, :baz) {
          data_type :bit
          name 'bazbaz'
          width 2
          array_size [2]
        }

        expect(feature.declarations(:domain_a, :variable)).to match([
          match_declaration('bit foo'),
          match_declaration('rand bit barbar')
        ])
        expect(feature.declarations(:domain_b, :variable)).to match([
          match_declaration('bit [1:0] bazbaz[2]')
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
