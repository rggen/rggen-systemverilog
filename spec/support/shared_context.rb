# frozen_string_literal: true

RSpec.shared_context 'bit field rtl common' do
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  let(:array_port_format) do
    [:packed, :unpacked, :serialized].sample
  end

  def create_bit_fields(&body)
    configuration = create_configuration(
      enable_wide_register: true, array_port_format: array_port_format
    )
    create_sv_rtl(configuration, &body).bit_fields
  end
end

RSpec.shared_context 'bit field ral common' do
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :enable_wide_register])
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
  end
end
