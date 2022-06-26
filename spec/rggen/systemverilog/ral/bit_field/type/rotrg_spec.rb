# frozen_string_literal: true

RSpec.describe 'bit_field/type/rotrg' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rotrg])
  end

  specify 'アクセス属性はRO' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rotrg }
      end
    end

    expect(sv_ral.bit_fields[0].access).to eq 'RO'
  end
end
