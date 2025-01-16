#! frozen_string_literal: true

RSpec.describe 'register_block/protocol/native' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, :protocol)
    RgGen.enable(:register_block, :protocol, [:native])
  end

  describe 'configuration' do
    specify 'プロトコル名は:native' do
      configuration = create_configuration(protocol: :native)
      expect(configuration).to have_property(:protocol, :native)
    end
  end

  describe 'sv rtl' do
    include_context 'sv rtl common'

    before(:all) do
      RgGen.enable(:register_block, [:name, :byte_size])
      RgGen.enable(:register, [:name, :offset_address, :size, :type])
      RgGen.enable(:register, :type, :external)
      RgGen.enable(:register_block, :sv_rtl_top)
    end

    let(:address_width) do
      16
    end

    let(:bus_width) do
      32
    end

    let(:register_block) do
      create_register_block do
        name 'block_0'
        byte_size 256
        register { name 'register_0'; offset_address 0x00; size [1]; type :external }
        register { name 'register_1'; offset_address 0x10; size [1]; type :external }
        register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end
    end

    def create_register_block(&)
      configuration =
        create_configuration(
          address_width:, bus_width:, protocol: :native
        )
      create_sv_rtl(configuration, &).register_blocks.first
    end

    it 'パラメータ#strobe_widthを持つ' do
      expect(register_block).to have_parameter(
        :strobe_width,
        name: 'STROBE_WIDTH', parameter_type: :parameter,
        data_type: :int, default: bus_width / 8
      )
    end

    it 'インターフェースポート#csrbus_ifを持つ' do
      expect(register_block).to have_interface_port(
        :csrbus_if,
        name: 'csrbus_if', interface_type: 'rggen_bus_if', modport: 'slave'
      )
    end

    describe '#generate_code' do
      it 'rggen_native_adapterをインスタンスするコードを生成する' do
        expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_native_adapter #(
            .ADDRESS_WIDTH        (ADDRESS_WIDTH),
            .LOCAL_ADDRESS_WIDTH  (8),
            .BUS_WIDTH            (32),
            .STROBE_WIDTH         (STROBE_WIDTH),
            .REGISTERS            (3),
            .PRE_DECODE           (PRE_DECODE),
            .BASE_ADDRESS         (BASE_ADDRESS),
            .BYTE_SIZE            (256),
            .ERROR_STATUS         (ERROR_STATUS),
            .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
            .INSERT_SLICER        (INSERT_SLICER)
          ) u_adapter (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .csrbus_if    (csrbus_if),
            .register_if  (register_if)
          );
        CODE
      end
    end
  end
end
