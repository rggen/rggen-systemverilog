# frozen_string_literal: true

RSpec.describe 'register/type/external' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :fold_sv_interface_port])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register, [:name, :type, :offset_address, :size])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:bit_field, :name)
  end

  let(:registers) do
    ral = create_sv_ral do
      byte_size 256
      register { name 'register_0'; offset_address 0x00; type :external; size [1] }
      register { name 'register_1'; offset_address 0x80; type :external; size [32] }
    end
    ral.registers
  end

  it '外部レジスタブロックモデル変数#ral_modelを持つ' do
    expect(registers[0]).to have_variable(
      :register_block, :ral_model,
      name: 'register_0', data_type: 'REGISTER_0', random: true
    )
    expect(registers[1]).to have_variable(
      :register_block, :ral_model,
      name: 'register_1', data_type: 'REGISTER_1', random: true
    )
  end

  it 'パラメータ#model_typeと#integrateを持つ' do
    expect(registers[0]).to have_parameter(
      :register_block, :model_type,
      name: 'REGISTER_0', data_type: 'type', default: 'rggen_ral_block'
    )
    expect(registers[0]).to have_parameter(
      :register_block, :integrate_model,
      name: 'INTEGRATE_REGISTER_0', data_type: 'bit', default: 1
    )
    expect(registers[1]).to have_parameter(
      :register_block, :model_type,
      name: 'REGISTER_1', data_type: 'type', default: 'rggen_ral_block'
    )
    expect(registers[1]).to have_parameter(
      :register_block, :integrate_model,
      name: 'INTEGRATE_REGISTER_1', data_type: 'bit', default: 1
    )
  end

  describe '#constructors' do
    it '外部レジスタブロックモデルの生成と構成を行うコードを出力する' do
      code_block = RgGen::Core::Utility::CodeUtility::CodeBlock.new
      registers.flat_map(&:constructors).each do |constructor|
        code_block << [constructor, "\n"]
      end

      expect(code_block).to match_string(<<~'CODE')
        `rggen_ral_create_block(register_0, 8'h00, this, INTEGRATE_REGISTER_0)
        `rggen_ral_create_block(register_1, 8'h80, this, INTEGRATE_REGISTER_1)
      CODE
    end
  end
end
