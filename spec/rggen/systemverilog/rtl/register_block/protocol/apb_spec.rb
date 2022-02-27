# frozen_string_literal: true

RSpec.describe 'register_block/protocol/apb' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, :protocol)
    RgGen.enable(:register_block, :protocol, [:apb])
  end

  describe 'configuration' do
    specify 'プロトコル名は:apb' do
      configuration = create_configuration(protocol: :apb)
      expect(configuration).to have_property(:protocol, :apb)
    end

    it '32ビットを超えるバス幅に対応しない' do
      [8, 16, 32].each do |bus_width|
        expect {
          create_configuration(bus_width: bus_width, protocol: :apb)
        }.not_to raise_error
      end

      [64, 128, 256].each do |bus_width|
        expect {
          create_configuration(bus_width: bus_width, protocol: :apb)
        }.to raise_configuration_error "bus width over 32 bit is not supported: #{bus_width}"
      end
    end

    it '32ビットを超えるアドレス幅に対応しない' do
      [2, 32, rand(3..31)].each do |address_width|
        expect {
          create_configuration(address_width: address_width, protocol: :apb)
        }.not_to raise_error
      end

      [33, 34, rand(35..64)].each do |address_width|
        expect {
          create_configuration(address_width: address_width, protocol: :apb)
        }.to raise_configuration_error "address width over 32 bit is not supported: #{address_width}"
      end
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

    let(:address_width) { 16 }

    let(:bus_width) { 32 }

    def create_register_block(&body)
      configuration = create_configuration(
        address_width: address_width,
        bus_width: bus_width,
        protocol: :apb
      )
      create_sv_rtl(configuration, &body).register_blocks.first
    end

    it 'インターフェースポート#apb_ifを持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register { name 'register_0'; offset_address 0x00; size [1]; type :external }
      end

      expect(register_block).to have_interface_port(
        :apb_if,
        name: 'apb_if', interface_type: 'rggen_apb_if', modport: 'slave'
      )
    end

    describe '#generate_code' do
      it 'rggen_apb_adapterをインスタンスするコードを生成する' do
        register_block = create_register_block do
          name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
        end

        expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_apb_adapter #(
            .ADDRESS_WIDTH        (ADDRESS_WIDTH),
            .LOCAL_ADDRESS_WIDTH  (8),
            .BUS_WIDTH            (32),
            .REGISTERS            (3),
            .PRE_DECODE           (PRE_DECODE),
            .BASE_ADDRESS         (BASE_ADDRESS),
            .BYTE_SIZE            (256),
            .ERROR_STATUS         (ERROR_STATUS),
            .DEFAULT_READ_DATA    (DEFAULT_READ_DATA)
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
