# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RAL::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:components) do
    register_block = create_component(nil, :register_block)
    register_file = create_component(register_block, :register_file)
    register = create_component(register_file, :register)
    bit_field = create_component(register, :bit_field)
    [register_block, register_file, register, bit_field]
  end

  let(:features) do
    components.map do |component|
      described_class.new(:foo, nil, component) { |f| component.add_feature(f) }
    end
  end

  def create_component(parent, layer)
    RgGen::SystemVerilog::Common::Component.new(parent, 'component', layer, configuration, register_map)
  end

  describe '#variable' do
    specify '規定の宣言追加先は一段上の階層' do
      features[1].instance_eval { variable :foo, data_type: :bit }
      features[2].instance_eval { variable :bar, name: 'barbar', data_type: :bit, random: :rand }
      features[3].instance_eval { variable :baz, name: 'bazbaz', data_type: :bit, width: 2, array_size: [2] }

      expect(components[0]).to have_declaration(:variable, 'bit foo')
      expect(components[1]).to have_declaration(:variable, 'rand bit barbar')
      expect(components[2]).to have_declaration(:variable, 'bit [1:0] bazbaz[2]')
    end
  end

  describe '#parameter' do
    specify '規定の宣言追加先は一段上の階層' do
      features[1].instance_eval { parameter :foo, default: 1 }
      features[2].instance_eval { parameter :bar, name: 'BAR', data_type: :int, default: 2 }
      features[3].instance_eval { parameter :baz, name: 'BAZ', data_type: :int, default: 3 }

      expect(components[0]).to have_declaration(:parameter, 'foo = 1')
      expect(components[1]).to have_declaration(:parameter, 'int BAR = 2')
      expect(components[2]).to have_declaration(:parameter, 'int BAZ = 3')
    end
  end
end
