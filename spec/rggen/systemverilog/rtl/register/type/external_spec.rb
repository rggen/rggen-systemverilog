# frozen_string_literal: true

RSpec.describe 'register/type/external' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register, [:name, :type, :offset_address, :size])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:bit_field, :name)
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
  end

  def create_registers(&body)
    configuration = create_configuration
    create_sv_rtl(configuration, &body).registers
  end

  it 'インターフェースポート#bus_ifを持つ' do
    registers = create_registers do
      byte_size 256
      register { name 'register_0'; offset_address 0x00; type :external; size [1] }
    end

    expect(registers[0]).to have_interface_port(
      :register_block, :bus_if,
      name: 'register_0_bus_if', interface_type: 'rggen_bus_if', modport: 'master'
    )
  end

  describe '#generate_code' do
    it 'rggen_exernal_registerをインスタンスするコードを出力する' do
      registers = create_registers do
        byte_size 256
        register { name 'register_0'; offset_address 0x00; type :external; size [1] }
        register { name 'register_1'; offset_address 0x80; type :external; size [32] }
      end

      expect(registers[0]).to generate_code(:register, :top_down, <<~'CODE')
        rggen_external_register #(
          .ADDRESS_WIDTH  (8),
          .BUS_WIDTH      (32),
          .START_ADDRESS  (8'h00),
          .END_ADDRESS    (8'h03)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[0]),
          .bus_if       (register_0_bus_if)
        );
      CODE

      expect(registers[1]).to generate_code(:register, :top_down, <<~'CODE')
        rggen_external_register #(
          .ADDRESS_WIDTH  (8),
          .BUS_WIDTH      (32),
          .START_ADDRESS  (8'h80),
          .END_ADDRESS    (8'hff)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[1]),
          .bus_if       (register_1_bus_if)
        );
      CODE
    end
  end
end
