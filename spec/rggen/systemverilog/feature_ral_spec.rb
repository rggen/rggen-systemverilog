# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog
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
        expect(feature).to have_identifier(:foo, 'foo')

        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: :rand)
        expect(feature).to have_identifier(:bar, 'barbar')

        feature.send(:variable, :domain_b, :baz) { |v|
          v.data_type :bit
          v.name 'bazbaz'
          v.width 2
          v.array_size [2]
        }
        expect(feature).to have_identifier(:baz, 'bazbaz')
      end

      specify '定義した変数の識別子はコンポーネント経由で参照できる' do
        feature.send(:variable, :domain_a, :foo, data_type: :bit)
        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: true)
        feature.send(:variable, :domain_b, :baz) { |v|
          v.data_type :bit
          v.name 'bazbaz'
          v.width 2
          v.array_size [2]
        }
        component.build

        expect(component).to have_identifier(:foo, 'foo')
        expect(component).to have_identifier(:bar, 'barbar')
        expect(component).to have_identifier(:baz, 'bazbaz')
      end

      specify '定義した変数の宣言は#declarationsで参照できる' do
        feature.send(:variable, :domain_a, :foo, data_type: :bit)
        feature.send(:variable, :domain_a, :bar, name: 'barbar', data_type: :bit, random: true)
        feature.send(:variable, :domain_b, :baz) { |v|
          v.data_type :bit
          v.name 'bazbaz'
          v.width 2
          v.array_size [2]
        }

        expect(feature).to have_declaration(:domain_a, :variable, 'bit foo')
        expect(feature).to have_declaration(:domain_a, :variable, 'rand bit barbar')
        expect(feature).to have_declaration(:domain_b, :variable, 'bit [1:0] bazbaz[2]')
      end
    end

    describe '#parameter' do
      specify 'ハンドル名で、定義したパラメータの識別子を参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        expect(feature).to have_identifier(:foo, 'foo')

        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        expect(feature).to have_identifier(:bar, 'BAR')

        feature.send(:parameter, :domain_b, :baz) { |p|
          p.name 'BAZ'
          p.data_type :int
          p.default 3
        }
        expect(feature).to have_identifier(:baz, 'BAZ')
      end

      specify '定義したパラメータの識別子はコンポーネント経由で参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        feature.send(:parameter, :domain_b, :baz) { |p|
          p.name 'BAZ'
          p.data_type :int
          p.default 3
        }
        component.build

        expect(component).to have_identifier(:foo, 'foo')
        expect(component).to have_identifier(:bar, 'BAR')
        expect(component).to have_identifier(:baz, 'BAZ')
      end

      specify '定義したパラメータの宣言は#declarationsで参照できる' do
        feature.send(:parameter, :domain_a, :foo, default: 1)
        feature.send(:parameter, :domain_a, :bar, name: 'BAR',data_type: :int, default: 2)
        feature.send(:parameter, :domain_b, :baz) { |p|
          p.name 'BAZ'
          p.data_type :int
          p.default 3
        }

        expect(feature).to have_declaration(:domain_a, :parameter, 'foo = 1')
        expect(feature).to have_declaration(:domain_a, :parameter, 'int BAR = 2')
        expect(feature).to have_declaration(:domain_b, :parameter, 'int BAZ = 3')
      end
    end
  end
end
