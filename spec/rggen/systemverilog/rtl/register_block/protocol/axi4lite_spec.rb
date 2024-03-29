# frozen_string_literal: true

RSpec.describe 'register_block/protocol/axi4lite' do
  include_context 'configuration common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, :protocol)
    RgGen.enable(:register_block, :protocol, [:axi4lite])
  end

  describe 'configuration' do
    specify 'プロトコル名は:axi4lite' do
      configuration = create_configuration(protocol: :axi4lite)
      expect(configuration).to have_property(:protocol, :axi4lite)
    end

    specify '32/64ビット以外のバス幅は未対応' do
      [32, 64].each do |bus_width|
        expect {
          create_configuration(bus_width: bus_width, protocol: :axi4lite)
        }.not_to raise_error
      end

      [8, 16, 128, 256].each do |bus_width|
        expect {
          create_configuration(bus_width: bus_width, protocol: :axi4lite)
        }.to raise_configuration_error "bus width either 32 bit or 64 bit is only supported: #{bus_width}"
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
        protocol: :axi4lite
      )
      create_sv_rtl(configuration, &body).register_blocks.first
    end

    it 'パラメータ#id_width/#write_firstを持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register { name 'register_0'; offset_address 0x00; size [1]; type :external }
      end

      expect(register_block).to have_parameter(
        :id_width,
        name: 'ID_WIDTH', parameter_type: :parameter, data_type: :int, default: 0
      )

      expect(register_block).to have_parameter(
        :write_first,
        name: 'WRITE_FIRST', parameter_type: :parameter, data_type: :bit, default: 1
      )
    end

    it 'インターフェースポート#axi4lite_ifを持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register { name 'register_0'; offset_address 0x00; size [1]; type :external }
      end

      expect(register_block).to have_interface_port(
        :axi4lite_if,
        name: 'axi4lite_if', interface_type: 'rggen_axi4lite_if', modport: 'slave'
      )
    end

    describe '#generate_code' do
      it 'rggen_axi4lite_adapterをインスタンスするコードを生成する' do
        register_block = create_register_block do
          name 'block_0'
          byte_size 256
          register { name 'register_0'; offset_address 0x00; size [1]; type :external }
          register { name 'register_1'; offset_address 0x10; size [1]; type :external }
          register { name 'register_2'; offset_address 0x20; size [1]; type :external }
        end

        expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_axi4lite_adapter #(
            .ID_WIDTH             (ID_WIDTH),
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
            .WRITE_FIRST          (WRITE_FIRST)
          ) u_adapter (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .axi4lite_if  (axi4lite_if),
            .register_if  (register_if)
          );
        CODE
      end
    end
  end
end
