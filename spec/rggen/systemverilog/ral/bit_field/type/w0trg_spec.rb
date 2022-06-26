# frozen_string_literal: true

RSpec.describe 'bit_field/type/w0trg' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:w0trg])
  end

  specify 'モデル名はrggen_ral_w0trg_field' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :w0trg }
      end
    end
    expect(sv_ral.bit_fields[0].model_name).to eq 'rggen_ral_w0trg_field'
  end
end
