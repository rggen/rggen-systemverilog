# frozen_string_literal: true

RSpec.shared_context 'bit field rtl common' do
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register, :array_port_format])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
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
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:bus_width])
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
  end
end

RSpec.shared_context 'sv rtl package common' do
  include_context 'sv rtl common'

  def build_sv_rtl_package_factory(builder)
    builder.build_factory(:output, :sv_rtl_package)
  end

  def create_sv_rtl_package(configuration = nil, &data_block)
    configuration = default_configuration if configuration.nil?
    register_map = create_register_map(configuration) { register_block(&data_block) }
    @sv_rtl_package_factory[0] ||= build_sv_rtl_package_factory(RgGen.builder)
    @sv_rtl_package_factory[0].create(configuration, register_map)
  end

  def delete_sv_rtl_package_factory
    @sv_rtl_package_factory.delete
  end

  before(:all) do
    @sv_rtl_package_factory ||= []
  end
end
