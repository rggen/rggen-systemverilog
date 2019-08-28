# frozen_string_literal: true

RSpec.describe 'bit_field/type/reserved' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:reserved, :rw])
  end

  describe '#access' do
    it 'ROを返す' do
      sv_ral = create_sv_ral do
        register do
          name :foo
          bit_field { name :foo; bit_assignment lsb: 1; type :reserved }
        end
      end

      expect(sv_ral.bit_fields[0].access).to eq 'RO'
    end
  end
end
