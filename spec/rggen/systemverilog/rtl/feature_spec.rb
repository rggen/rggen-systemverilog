# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RTL::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:components) do
    register_block = create_component(nil, :register_block)
    register = create_component(register_block, :register)
    bit_field = create_component(register, :bit_field)
    [register_block, register, bit_field]
  end

  let(:features) do
    components.map do |component|
      described_class.new(:foo, nil, component) { |f| component.add_feature(f) }
    end
  end

  def create_component(parent, layer)
    RgGen::SystemVerilog::Common::Component.new(parent, 'component', layer, configuration, register_map)
  end

  describe '#logic' do
    specify '既定の宣言追加先は自身の階層' do
      features[0].instance_eval { logic :foo }
      features[1].instance_eval { logic :bar, name: 'barbar', width: 2, array_size: [2] }
      features[2].instance_eval { logic :baz, name: 'bazbaz', width: 3, array_size: [3, 2] }

      expect(components[0]).to have_declaration(:variable, 'logic foo')
      expect(components[1]).to have_declaration(:variable, 'logic [1:0][1:0] barbar')
      expect(components[2]).to have_declaration(:variable, 'logic [2:0][1:0][2:0] bazbaz')
    end
  end

  describe '#interface' do
    specify '既定の宣言追加先は自身の階層' do
      features[0].instance_eval { interface :foo, interface_type: :foo_if }
      features[1].instance_eval { interface :bar, interface_type: :bar_if, name: 'barbar', array_size: [2] }
      features[2].instance_eval { interface :baz, interface_type: :baz_if, name: 'bazbaz', parameter_values: [1, 2] }

      expect(components[0]).to have_declaration(:variable, 'foo_if foo()')
      expect(components[1]).to have_declaration(:variable, 'bar_if barbar[2]()')
      expect(components[2]).to have_declaration(:variable, 'baz_if #(1, 2) bazbaz()')
    end
  end

  describe '#input' do
    specify '既定の宣言追加先はregister_block階層' do
      features[0].instance_eval { input :foo }
      features[1].instance_eval { input :bar, name: 'barbar', width: 2, array_size: [2] }
      features[2].instance_eval { input :baz, name: 'bazbaz', width: 3, array_size: [3, 2] }

      expect(components[0]).to have_declaration(:port, 'input foo')
      expect(components[0]).to have_declaration(:port, 'input [1:0][1:0] barbar')
      expect(components[0]).to have_declaration(:port, 'input [2:0][1:0][2:0] bazbaz')
    end
  end

  describe '#output' do
    specify '既定の宣言追加先はregister_block階層' do
      features[0].instance_eval { output :foo }
      features[1].instance_eval { output :bar, name: 'barbar', width: 2, array_size: [2] }
      features[2].instance_eval { output :baz, name: 'bazbaz', width: 3, array_size: [3, 2] }

      expect(components[0]).to have_declaration(:port, 'output foo')
      expect(components[0]).to have_declaration(:port, 'output [1:0][1:0] barbar')
      expect(components[0]).to have_declaration(:port, 'output [2:0][1:0][2:0] bazbaz')
    end
  end

  describe '#interface_port' do
    specify '既定の宣言追加先はregister_block階層' do
      features[0].instance_eval { interface_port :foo, interface_type: :foo_if }
      features[1].instance_eval { interface_port :bar, interface_type: :bar_if, name: 'barbar', modport: :bar, array_size: [2] }
      features[2].instance_eval { interface_port :baz, interface_type: :baz_if, name: 'bazbaz', modport: [:baz, [:baz_0, :baz_1]] }

      expect(components[0]).to have_declaration(:port, 'foo_if foo')
      expect(components[0]).to have_declaration(:port, 'bar_if.bar barbar[2]')
      expect(components[0]).to have_declaration(:port, 'baz_if.baz bazbaz')
    end
  end

  describe '#parameter' do
    specify '既定の宣言追加先はregister_block階層' do
      features[0].instance_eval { parameter :foo, default: 1 }
      features[1].instance_eval { parameter :bar, name: 'BAR', data_type: :int, default: 2 }
      features[2].instance_eval { parameter :baz, name: 'BAZ', data_type: :integer, default: 3 }

      expect(components[0]).to have_declaration(:parameter, 'parameter foo = 1')
      expect(components[0]).to have_declaration(:parameter, 'parameter int BAR = 2')
      expect(components[0]).to have_declaration(:parameter, 'parameter integer BAZ = 3')
    end
  end

  describe '#localparam' do
    specify '既定の宣言追加先は自身の階層' do
      features[0].instance_eval { localparam :foo, default: 1 }
      features[1].instance_eval { localparam :bar, name: 'BAR', data_type: :int, default: 2 }
      features[2].instance_eval { localparam :baz, name: 'BAZ', data_type: :integer, default: 3 }

      expect(components[0]).to have_declaration(:parameter, 'localparam foo = 1')
      expect(components[1]).to have_declaration(:parameter, 'localparam int BAR = 2')
      expect(components[2]).to have_declaration(:parameter, 'localparam integer BAZ = 3')
    end
  end
end
