# frozen_string_literal: true

RSpec.describe 'register/type/indirect' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:ro, :rw, :wo, :reserved])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  let(:registers) do
    sv_rtl = create_sv_rtl do
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x08
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_3'
        offset_address 0x10
        type [:indirect, ['register_0.bit_field_0', 1]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_4'
        offset_address 0x14
        size [2]
        type [:indirect, 'register_0.bit_field_1']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x18
        size [2, 4]
        type [:indirect, 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x1c
        size [2, 4]
        type [:indirect, ['register_0.bit_field_0', 0], 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x20
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_8'
        offset_address 0x24
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_9'
        offset_address 0x28
        size [2]
        type [:indirect, 'register_1', ['register_2', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end
    end
    sv_rtl.registers
  end

  it 'logic変数#indirect_indexを持つ' do
    expect(registers[3]).to have_variable(
      :register, :indirect_index,
      name: 'indirect_index', data_type: :logic, width: 1
    )

    expect(registers[4]).to have_variable(
      :register, :indirect_index,
      name: 'indirect_index', data_type: :logic, width: 2
    )

    expect(registers[5]).to have_variable(
      :register, :indirect_index,
      name: 'indirect_index', data_type: :logic, width: 6
    )

    expect(registers[6]).to have_variable(
      :register, :indirect_index,
      name: 'indirect_index', data_type: :logic, width: 7
    )
  end

  describe '#generate_code' do
    it 'rggen_indirect_registerをインスタンスするコードを出力する' do
      expect(registers[3]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[0+:1]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h10),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (1),
          .INDIRECT_INDEX_VALUE ({1'h1})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[3]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[4]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[8+:2]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h14),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (2),
          .INDIRECT_INDEX_VALUE ({i[0+:2]})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[4+i]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[8+:2], register_if[0].value[16+:4]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h18),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (6),
          .INDIRECT_INDEX_VALUE ({i[0+:2], j[0+:4]})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[6+4*i+j]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[0+:1], register_if[0].value[8+:2], register_if[0].value[16+:4]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h1c),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (7),
          .INDIRECT_INDEX_VALUE ({1'h0, i[0+:2], j[0+:4]})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[14+4*i+j]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[0+:1]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (0),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h20),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (1),
          .INDIRECT_INDEX_VALUE ({1'h0})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[22]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[8]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[0].value[0+:1]};
        rggen_indirect_register #(
          .READABLE             (0),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h24),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (1),
          .INDIRECT_INDEX_VALUE ({1'h0})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[23]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE

      expect(registers[9]).to generate_code(:register, :top_down, <<~'CODE')
        assign indirect_index = {register_if[1].value[0+:2], register_if[2].value[0+:2]};
        rggen_indirect_register #(
          .READABLE             (1),
          .WRITABLE             (1),
          .ADDRESS_WIDTH        (8),
          .OFFSET_ADDRESS       (8'h28),
          .BUS_WIDTH            (32),
          .DATA_WIDTH           (32),
          .VALID_BITS           (32'h00000001),
          .INDIRECT_INDEX_WIDTH (4),
          .INDIRECT_INDEX_VALUE ({i[0+:2], 2'h0})
        ) u_register (
          .i_clk            (i_clk),
          .i_rst_n          (i_rst_n),
          .register_if      (register_if[24+i]),
          .i_indirect_index (indirect_index),
          .bit_field_if     (bit_field_if)
        );
      CODE
    end
  end
end
