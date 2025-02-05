#! frozen_string_literal: true

RSpec.describe 'register_block/protocol/avalon' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:protocol, :bus_width, :name, :byte_size])
    RgGen.enable(:register_block, :protocol, [:apb, :avalon])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:register_block, :sv_rtl_top)
  end

  def create_register_block(**config_values, &)
    configuration = create_configuration(**config_values)
    register_map = create_register_map(configuration) do
      register_block do
        name 'block'
        byte_size 256
        block_given? && instance_eval(&)
      end
    end
    register_map.register_blocks.first
  end

  specify 'プロトコル名は:avalon' do
    configuration = create_configuration(protocol: :avalon)
    expect(configuration).to have_property(:protocol, :avalon)

    register_block = create_register_block { protocol :avalon }
    expect(register_block).to have_property(:protocol, :avalon)
  end

  describe 'エラーチェック' do
    context 'アドレス幅が64ビットを超える場合' do
      it 'SourceErrorを起こす' do
        [8, 16, 32, 64].each do |width|
          expect {
            create_register_block(address_width: width, protocol: :avalon)
          }.not_to raise_error

          expect {
            create_register_block(address_width: width) { protocol :avalon }
          }.not_to raise_error
        end

        [65, 128, 256].each do |width|
          message = "address width over 64 bits is not supported: #{width}"

          expect {
            create_register_block(address_width: width, protocol: :avalon)
          }.to raise_source_error message

          expect {
            create_register_block(address_width: width) { protocol :avalon }
          }.to raise_source_error message
        end
      end

      context 'バス幅が1024ビットを超える場合' do
        it 'SourceErrorを起こす' do
          [8, 16, 32, 64, 128, 256, 512, 1024].each do |width|
            expect {
              create_register_block(bus_width: width, protocol: :avalon)
            }.not_to raise_error

            expect {
              create_register_block(bus_width: 32) { bus_width width; protocol :avalon }
            }.not_to raise_error
          end

          [2048, 4096].each do |width|
            message = "bus width over 1024 bits is not supported: #{width}"

            expect {
              create_register_block(bus_width: width, protocol: :avalon)
            }.to raise_source_error message

            expect {
              create_register_block(bus_width: 32) { bus_width width; protocol :avalon }
            }.to raise_source_error message
          end
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

    let(:register_block) do
      configuration =
        create_configuration(
          address_width:, bus_width:, protocol: :avalon
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

    it 'インターフェースポート#avalon_ifを持つ' do
      expect(register_block).to have_interface_port(
        :avalon_if,
        name: 'avalon_if', interface_type: 'rggen_avalon_if', modport: 'agent'
      )
    end

    describe '#generate_code' do
      it 'rggen_avalon_adapterをインスタンスするコードを生成する' do
        expect(register_block).to generate_code(:register_block, :top_down, <<~'CODE')
          rggen_avalon_adapter #(
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
            .avalon_if    (avalon_if),
            .register_if  (register_if)
          );
        CODE
      end
    end
  end
end
