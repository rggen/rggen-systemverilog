# frozen_string_literal: true

RSpec.describe 'bit_field/type/rwtrg' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:rwtrg])
  end

  specify 'アクセス属性はRW' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rwtrg; initial_value 0 }
      end
    end

    expect(sv_ral.bit_fields[0].access).to eq 'RW'
  end
end
