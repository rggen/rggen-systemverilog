# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RTL::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new('configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new('register_map', nil, configuration)
  end

  let(:component) do
    RgGen::Core::OutputBase::Component.new('component', nil, configuration, register_map)
  end

  let(:feature) do
    described_class.new(:foo, nil, component) do |f|
      component.add_feature(f)
    end
  end

  describe '#logic' do
    specify 'ハンドル名で、定義した変数の識別子を参照できる' do
      feature.send(:logic, :domain_a, :foo)
      expect(feature).to have_identifier(:foo, 'foo')

      feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      expect(feature).to have_identifier(:bar, 'barbar')

      feature.send(:logic, :domain_b, :baz) { |l|
        l.name 'bazbaz'
        l.width 2
        l.array_size [2]
      }
      expect(feature).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した変数の識別子はコンポーネント経由で参照できる' do
      feature.send(:logic, :domain_a, :foo)
      feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:logic, :domain_b, :baz) { |l|
        l.name 'bazbaz'
        l.width 2
        l.array_size [2]
      }
      component.build

      expect(component).to have_identifier(:foo, 'foo')
      expect(component).to have_identifier(:bar, 'barbar')
      expect(component).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した変数の宣言は#declarationsで参照できる' do
      feature.send(:logic, :domain_a, :foo)
      feature.send(:logic, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:logic, :domain_b, :baz) { |l|
        l.name 'bazbaz'
        l.width 2
        l.array_size [2]
      }

      expect(feature).to have_declaration(:domain_a, :variable, 'logic foo')
      expect(feature).to have_declaration(:domain_a, :variable, 'logic [1:0][1:0] barbar')
      expect(feature).to have_declaration(:domain_b, :variable, 'logic [1:0][1:0] bazbaz')
    end
  end

  describe '#interface' do
    specify 'ハンドル名で、定義したインターフェースの識別子を参照できる' do
      feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
      expect(feature).to have_identifier(:foo, 'foo')

      feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
      expect(feature).to have_identifier(:bar, 'barbar')

      feature.send(:interface, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.parameter_values [1, 2]
        i.variables [:baz_0, :baz_1]
      }
      expect(feature).to have_identifier(:baz, 'bazbaz')
      expect(feature.baz.baz_0).to match_identifier('bazbaz.baz_0')
      expect(feature.baz.baz_1).to match_identifier('bazbaz.baz_1')
    end

    specify '定義したインターフェースの識別子はコンポーネント経由で参照できる' do
      feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
      feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
      feature.send(:interface, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.parameter_values [1, 2]
        i.variables [:baz_0, :baz_1]
      }
      component.build

      expect(component).to have_identifier(:foo, 'foo')
      expect(component).to have_identifier(:bar, 'barbar')
      expect(component).to have_identifier(:baz, 'bazbaz')
      expect(component.baz.baz_0).to match_identifier('bazbaz.baz_0')
      expect(component.baz.baz_1).to match_identifier('bazbaz.baz_1')
    end

    specify '定義したインターフェースの宣言は#declarationsで参照できる' do
      feature.send(:interface, :domain_a, :foo, interface_type: :foo_if)
      feature.send(:interface, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', array_size: [2])
      feature.send(:interface, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.parameter_values [1, 2]
        i.variables [:baz_0, :baz_1]
      }

      expect(feature).to have_declaration(:domain_a, :variable, 'foo_if foo()')
      expect(feature).to have_declaration(:domain_a, :variable, 'bar_if barbar[2]()')
      expect(feature).to have_declaration(:domain_b, :variable, 'baz_if #(1, 2) bazbaz()')
    end
  end

  describe '#input' do
    specify 'ハンドル名で、定義した入力ポートの識別子を参照できる' do
      feature.send(:input, :domain_a, :foo)
      expect(feature).to have_identifier(:foo, 'foo')

      feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      expect(feature).to have_identifier(:bar, 'barbar')

      feature.send(:input, :domain_b, :baz) { |i|
        i.name 'bazbaz'
        i.width 2
        i.array_size [2]
      }
      expect(feature).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した入力ポートの識別子はコンポーネント経由で参照できる' do
      feature.send(:input, :domain_a, :foo)
      feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:input, :domain_b, :baz) { |i|
        i.name 'bazbaz'
        i.width 2
        i.array_size [2]
      }
      component.build

      expect(component).to have_identifier(:foo, 'foo')
      expect(component).to have_identifier(:bar, 'barbar')
      expect(component).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した入力ポートの宣言は#declarationsで参照できる' do
      feature.send(:input, :domain_a, :foo)
      feature.send(:input, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:input, :domain_b, :baz) { |i|
        i.name 'bazbaz'
        i.width 2
        i.array_size [2]
      }

      expect(feature).to have_declaration(:domain_a, :port, 'input foo')
      expect(feature).to have_declaration(:domain_a, :port, 'input [1:0][1:0] barbar')
      expect(feature).to have_declaration(:domain_b, :port, 'input [1:0][1:0] bazbaz')
    end
  end

  describe '#output' do
    specify 'ハンドル名で、定義した出力ポートの識別子を参照できる' do
      feature.send(:output, :domain_a, :foo)
      expect(feature).to have_identifier(:foo, 'foo')

      feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      expect(feature).to have_identifier(:bar, 'barbar')

      feature.send(:output, :domain_b, :baz) { |o|
        o.name 'bazbaz'
        o.width 2
        o.array_size [2]
      }
      expect(feature).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した出力ポートの識別子はコンポーネント経由で参照できる' do
      feature.send(:output, :domain_a, :foo)
      feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:output, :domain_b, :baz) { |o|
        o.name 'bazbaz'
        o.width 2
        o.array_size [2]
      }
      component.build

      expect(component).to have_identifier(:foo, 'foo')
      expect(component).to have_identifier(:bar, 'barbar')
      expect(component).to have_identifier(:baz, 'bazbaz')
    end

    specify '定義した出力ポートの宣言は#declarationsで参照できる' do
      feature.send(:output, :domain_a, :foo)
      feature.send(:output, :domain_a, :bar, name: 'barbar', width: 2, array_size: [2])
      feature.send(:output, :domain_b, :baz) { |o|
        o.name 'bazbaz'
        o.width 2
        o.array_size [2]
      }

      expect(feature).to have_declaration(:domain_a, :port, 'output foo')
      expect(feature).to have_declaration(:domain_a, :port, 'output [1:0][1:0] barbar')
      expect(feature).to have_declaration(:domain_b, :port, 'output [1:0][1:0] bazbaz')
    end
  end

  describe '#interface_port' do
    specify 'ハンドル名で、定義したインターフェースポートの識別子を参照できる' do
      feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
      expect(feature).to have_identifier(:foo, 'foo')

      feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
      expect(feature).to have_identifier(:bar, 'barbar')

      feature.send(:interface_port, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.modport :baz, [:baz_0, :baz_1]
        i.array_size [2]
      }
      expect(feature).to have_identifier(:baz, 'bazbaz')
      expect(feature.baz.baz_0).to match_identifier('bazbaz.baz_0')
      expect(feature.baz.baz_1).to match_identifier('bazbaz.baz_1')
    end

    specify '定義したインターフェースポートの識別子はコンポーネント経由で参照できる' do
      feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
      feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
      feature.send(:interface_port, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.modport :baz, [:baz_0, :baz_1]
        i.array_size [2]
      }
      component.build

      expect(component).to have_identifier(:foo, 'foo')
      expect(component).to have_identifier(:bar, 'barbar')
      expect(component).to have_identifier(:baz, 'bazbaz')
      expect(component.baz.baz_0).to match_identifier('bazbaz.baz_0')
      expect(component.baz.baz_1).to match_identifier('bazbaz.baz_1')
    end

    specify '定義したインターフェースポートの宣言は#declarationsで参照できる' do
      feature.send(:interface_port, :domain_a, :foo, interface_type: :foo_if)
      feature.send(:interface_port, :domain_a, :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2])
      feature.send(:interface_port, :domain_b, :baz) { |i|
        i.interface_type :baz_if
        i.name 'bazbaz'
        i.modport :baz, [:baz_0, :baz_1]
        i.array_size [2]
      }

      expect(feature).to have_declaration(:domain_a, :port, 'foo_if foo')
      expect(feature).to have_declaration(:domain_a, :port, 'bar_if.bar barbar[2]')
      expect(feature).to have_declaration(:domain_b, :port, 'baz_if.baz bazbaz[2]')
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

      expect(feature).to have_declaration(:domain_a, :parameter, 'parameter foo = 1')
      expect(feature).to have_declaration(:domain_a, :parameter, 'parameter int BAR = 2')
      expect(feature).to have_declaration(:domain_b, :parameter, 'parameter int BAZ = 3')
    end
  end
end
