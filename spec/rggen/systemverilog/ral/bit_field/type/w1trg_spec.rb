# frozen_string_literal: true

RSpec.describe 'bit_field/type/w1trg' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:w1trg])
  end

  specify 'モデル名はrggen_ral_w1trg_field' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w1trg }
      end
    end
    expect(sv_ral.bit_fields[0].model_name).to eq 'rggen_ral_w1trg_field'
  end
end
