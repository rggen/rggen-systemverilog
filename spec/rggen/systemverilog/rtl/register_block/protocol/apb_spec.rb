# frozen_string_literal: true

RSpec.describe 'register_block/protocol/apb' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:protocol, :bus_width, :name, :byte_size])
    RgGen.enable(:register_block, :protocol, [:native, :apb])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:register_block, :sv_rtl_top)
  end

  def create_register_block(**config_values, &)
    configuration = create_configuration(**config_values)
    regiter_map = create_register_map(configuration) do
      register_block do
        name 'block'
        byte_size 4
        block_given? && instance_eval(&)
      end
    end
    regiter_map.register_blocks.first
  end

  specify 'プロトコル名は:apb' do
    configuration = create_configuration(protocol: :apb)
    expect(configuration).to have_property(:protocol, :apb)

    register_block = create_register_block { protocol :apb }
    expect(register_block).to have_property(:protocol, :apb)
  end

  describe 'エラーチェック' do
    context 'バス幅が32ビットを超える場合' do
      it 'RegiterMapErrorを起こす' do
        [8, 16, 32].each do |width|
          expect {
            create_register_block(bus_width: width, protocol: :apb)
          }.not_to raise_error

          expect {
            create_register_block(bus_width: 32) { bus_width width; protocol :apb }
          }.not_to raise_error
        end

        [64, 128, 256].each do |width|
          expect {
            create_register_block(bus_width: width, protocol: :apb)
          }.to raise_register_map_error "bus width over 32 bits is not supported: #{width}"

          expect {
            create_register_block(bus_width: 32) { bus_width width; protocol :apb }
          }.to raise_register_map_error "bus width over 32 bits is not supported: #{width}"
        end
      end
    end

    context 'アドレス幅が32ビットを超える場合' do
      it 'RegiterMapErrorを起こす' do
        [2, 32, rand(3..31)].each do |address_width|
          expect {
            create_register_block(address_width: address_width, protocol: :apb)
          }.not_to raise_error

          expect {
            create_register_block(address_width: address_width) { protocol :apb }
          }.not_to raise_error
        end

        [33, 34, rand(35..64)].each do |address_width|
          expect {
            create_register_block(address_width: address_width, protocol: :apb)
          }.to raise_register_map_error "address width over 32 bits is not supported: #{address_width}"

          expect {
            create_register_block(address_width: address_width) { protocol :apb }
          }.to raise_register_map_error "address width over 32 bits is not supported: #{address_width}"
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
        protocol: :apb
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

    it 'インターフェースポート#apb_ifを持つ' do
      expect(sv_rtl_top).to have_interface_port(
        :apb_if,
        name: 'apb_if', interface_type: 'rggen_apb_if', modport: 'slave'
      )
    end

    describe '#generate_code' do
      it 'rggen_apb_adapterをインスタンスするコードを生成する' do
        expect(sv_rtl_top).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_apb_adapter #(
            .ADDRESS_WIDTH        (ADDRESS_WIDTH),
            .LOCAL_ADDRESS_WIDTH  (8),
            .BUS_WIDTH            (32),
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
            .apb_if       (apb_if),
            .register_if  (register_if)
          );
        CODE
      end
    end
  end
end
