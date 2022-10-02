# frozen_string_literal: true

RSpec.describe 'bit_field/type/custom' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, :custom)
  end

  let(:bit_fields) do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom]; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_read: :none]; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, sw_read: :default]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, sw_read: :set]; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment width: 2; type [:custom, sw_read: :clear]; initial_value 0 }
      end

      register do
        name 'register_2'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_write: :none] }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, sw_write: :default]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, sw_write: :set]; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment width: 2; type [:custom, sw_write: :set_0]; initial_value 0 }
        bit_field { name 'bit_field_4'; bit_assignment width: 2; type [:custom, sw_write: :set_1]; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment width: 2; type [:custom, sw_write: :clear]; initial_value 0 }
        bit_field { name 'bit_field_6'; bit_assignment width: 2; type [:custom, sw_write: :clear_0]; initial_value 0 }
        bit_field { name 'bit_field_7'; bit_assignment width: 2; type [:custom, sw_write: :clear_1]; initial_value 0 }
        bit_field { name 'bit_field_8'; bit_assignment width: 2; type [:custom, sw_write: :toggle_0]; initial_value 0 }
        bit_field { name 'bit_field_9'; bit_assignment width: 2; type [:custom, sw_write: :toggle_1]; initial_value 0 }
      end

      register do
        name 'register_3'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, sw_write_once: true]; initial_value 0 }
      end

      register do
        name 'register_4'
        bit_field { name 'bit_field_0'; bit_assignment width: 2; type [:custom, hw_write: true]; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment width: 2; type [:custom, hw_set: true]; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment width: 2; type [:custom, hw_clear: true]; initial_value 0 }
      end
    end

    sv_ral.bit_fields
  end

  specify 'モデル名はrggen_ral_custom_field' do
    expect(bit_fields[0].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 0)'

    expect(bit_fields[1].model_name).to eq 'rggen_ral_custom_field #("NONE", "DEFAULT", 0, 0)'
    expect(bit_fields[2].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 0)'
    expect(bit_fields[3].model_name).to eq 'rggen_ral_custom_field #("SET", "DEFAULT", 0, 0)'
    expect(bit_fields[4].model_name).to eq 'rggen_ral_custom_field #("CLEAR", "DEFAULT", 0, 0)'

    expect(bit_fields[5].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "NONE", 0, 0)'
    expect(bit_fields[6].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 0)'
    expect(bit_fields[7].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "SET", 0, 0)'
    expect(bit_fields[8].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "SET_0", 0, 0)'
    expect(bit_fields[9].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "SET_1", 0, 0)'
    expect(bit_fields[10].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "CLEAR", 0, 0)'
    expect(bit_fields[11].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "CLEAR_0", 0, 0)'
    expect(bit_fields[12].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "CLEAR_1", 0, 0)'
    expect(bit_fields[13].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "TOGGLE_0", 0, 0)'
    expect(bit_fields[14].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "TOGGLE_1", 0, 0)'

    expect(bit_fields[15].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 1, 0)'

    expect(bit_fields[16].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 1)'
    expect(bit_fields[17].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 1)'
    expect(bit_fields[18].model_name).to eq 'rggen_ral_custom_field #("DEFAULT", "DEFAULT", 0, 1)'
  end
end
