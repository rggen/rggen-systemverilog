# frozen_string_literal: true

RSpec.describe 'register_block/protocol/wishbone' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:protocol, :bus_width, :name, :byte_size])
    RgGen.enable(:register_block, :protocol, [:native, :wishbone])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:register_block, :sv_rtl_top)
  end

  def create_register_block(**config_values, &)
    configuration = create_configuration(**config_values)
    regiter_map = create_register_map(configuration) do
      register_block do
        name 'block'
        byte_size 8
        block_given? && instance_eval(&)
      end
    end
    regiter_map.register_blocks.first
  end

  specify 'プロトコル名は:wishbone' do
    configuration = create_configuration(protocol: :wishbone)
    expect(configuration).to have_property(:protocol, :wishbone)

    register_block = create_register_block { protocol :wishbone }
    expect(register_block).to have_property(:protocol, :wishbone)
  end

  describe 'エラーチェック' do
    context 'バス幅が64ビットを超える場合' do
      it 'RegisterMapErrorを起こす' do
        [8, 16, 32, 64].each do |width|
          expect {
            create_register_block(bus_width: width, protocol: :wishbone)
          }.not_to raise_error

          expect {
            create_register_block(bus_width: 32) { bus_width width; protocol :wishbone }
          }.not_to raise_error
        end

        [128, 256].each do |width|
          message = "bus width over 64 bits is not supported: #{width}"

          expect {
            create_register_block(bus_width: width, protocol: :wishbone)
          }.to raise_register_map_error message

          expect {
            create_register_block(bus_width: 32) { bus_width width; protocol :wishbone }
          }.to raise_register_map_error message
        end
      end
    end
  end

  describe 'sv rtl' do
    let(:address_width) do
      16
    end

    let(:bus_width) do
      32
    end

    let(:sv_rtl_top) do
      configuration = create_configuration(
        address_width: address_width,
        bus_width: bus_width,
        protocol: :wishbone
      )
      sv_rtl = create_sv_rtl(configuration) do
        name 'block_0'
        byte_size 256
        register { name 'register_0'; offset_address 0x00; size [1]; type :external }
        register { name 'register_1'; offset_address 0x10; size [1]; type :external }
        register { name 'register_2'; offset_address 0x20; size [1]; type :external }
      end
      sv_rtl.register_blocks.first
    end

    it 'パラメータ#use_stallを持つ' do
      expect(sv_rtl_top).to have_parameter(
        :use_stall,
        name: 'USE_STALL', parameter_type: :parameter, data_type: :bit, default: 1
      )
    end

    it 'インターフェースポートwishbone_ifを持つ' do
      expect(sv_rtl_top).to have_interface_port(
        :wishbone_if,
        name: 'wishbone_if', interface_type: 'rggen_wishbone_if', modport: 'slave'
      )
    end

    describe '#generate_code' do
      it 'rggen_wishbone_adapterをインスタンスするコードを生成する' do
        expect(sv_rtl_top).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_wishbone_adapter #(
            .ADDRESS_WIDTH        (ADDRESS_WIDTH),
            .LOCAL_ADDRESS_WIDTH  (8),
            .BUS_WIDTH            (32),
            .REGISTERS            (3),
            .PRE_DECODE           (PRE_DECODE),
            .BASE_ADDRESS         (BASE_ADDRESS),
            .BYTE_SIZE            (256),
            .ERROR_STATUS         (ERROR_STATUS),
            .DEFAULT_READ_DATA    (DEFAULT_READ_DATA),
            .INSERT_SLICER        (INSERT_SLICER),
            .USE_STALL            (USE_STALL)
          ) u_adapter (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .wishbone_if  (wishbone_if),
            .register_if  (register_if)
          );
        CODE
      end
    end
  end
end
