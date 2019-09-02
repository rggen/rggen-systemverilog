
# frozen_string_literal: true

RSpec.describe 'bit_field/type/rws' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:rw, :rws])
  end

  specify 'アクセス属性はRW' do
    sv_ral = create_sv_ral do
      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rws; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :rws; initial_value 0; reference 'register_1.bit_field_0' }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end
    end

    expect(sv_ral.bit_fields[0].access).to eq 'RW'
    expect(sv_ral.bit_fields[1].access).to eq 'RW'
  end
end
