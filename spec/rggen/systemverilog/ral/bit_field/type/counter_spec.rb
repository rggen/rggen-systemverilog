# frozen_string_literal: true

RSpec.describe 'bit_field/type/counter' do
  include_context 'clean-up builder'
  include_context 'bit field ral common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:counter])
  end

  specify 'アクセス属性はRW' do
    sv_ral = create_sv_ral do
      register do
        name :foo
        bit_field { name :foo; bit_assignment lsb: 1; type :counter; initial_value 0 }
      end
    end

    expect(sv_ral.bit_fields[0].access).to eq 'RW'
  end
end
