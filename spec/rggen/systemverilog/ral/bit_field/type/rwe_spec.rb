# frozen_string_literal: true

RSpec.describe 'bit_field/type/rwe' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rw, :rwe])
  end

  specify 'モデル名はrggen_ral_rwe_field' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rwe; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :rwe; initial_value 0; reference 'register_1.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 2; type :rwe; initial_value 0; reference 'register_2' }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        bit_field { bit_assignment lsb: 0; type :rw; initial_value 0 }
      end
    end

    expect(sv_ral.bit_fields[0].model_name).to eq 'rggen_ral_rwe_field'
    expect(sv_ral.bit_fields[1].model_name).to eq 'rggen_ral_rwe_field'
    expect(sv_ral.bit_fields[2].model_name).to eq 'rggen_ral_rwe_field'
  end
end
