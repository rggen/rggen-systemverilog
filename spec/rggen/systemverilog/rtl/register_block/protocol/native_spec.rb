#! frozen_string_literal: true

RSpec.describe 'register_block/protocol/native' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:protocol, :bus_width, :name, :byte_size])
    RgGen.enable(:register_block, :protocol, [:apb, :native])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, :external)
    RgGen.enable(:register_block, :sv_rtl_top)
  end

  def create_register_block(**config_values, &)
    configuration = create_configuration(**config_values)
    register_map = create_register_map(configuration) do
      register_block do
        name 'block'
        byte_size 8
        block_given? && instance_eval(&)
      end
    end
    register_map.register_blocks.first
  end

  specify 'プロトコル名は:native' do
    configuration = create_configuration(protocol: :native)
    expect(configuration).to have_property(:protocol, :native)

    register_block = create_register_block { protocol :native }
    expect(register_block).to have_property(:protocol, :native)
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
          address_width:, bus_width:, protocol: :native
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

    it 'パラメータ#strobe_width/#use_read_strobeを持つ' do
      expect(register_block).to have_parameter(
        :strobe_width,
        name: 'STROBE_WIDTH', parameter_type: :parameter,
        data_type: :int, default: bus_width / 8
      )
      expect(register_block).to have_parameter(
        :use_read_strobe,
        name: 'USE_READ_STROBE', parameter_type: :parameter,
        data_type: :bit, default: 0
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
            .USE_READ_STROBE      (USE_READ_STROBE),
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
