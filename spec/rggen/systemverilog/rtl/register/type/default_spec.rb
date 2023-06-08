# frozen_string_literal: true

RSpec.describe 'register/type/default' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw, :ro, :wo])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  describe '#generate_code' do
    let(:registers) do
      sv_rtl = create_sv_rtl do
        byte_size 1024

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          size [2, step: 8]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          offset_address 0x50
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_6'
          offset_address 0x60
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          offset_address 0x70
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 8, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_8'
          offset_address 0x80
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :ro }
        end

        register do
          name 'register_9'
          offset_address 0x90
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wo; initial_value 0 }
        end

        register_file do
          name 'register_file_10'
          offset_address 0xa0
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x10
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4; type :rw; initial_value 0 }
            end
          end
        end

        register_file do
          name 'register_file_11'
          offset_address 0x200
          size [2, step: 32]
          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              offset_address 0x00
              size [2, step: 8]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4; type :rw; initial_value 0 }
            end
          end
        end
      end
      sv_rtl.registers
    end

    it 'rggen_default_registerをインスタンスするコードを出力する' do
      expect(registers[0]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h000),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[0]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[1]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h010+10'(4*i)),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[1+i]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[2]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h020+10'(4*(2*i+j))),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[5+2*i+j]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[3]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h030+10'(8*i)),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[9+i]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[4]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'hffffffff, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h040),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[11]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[5]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'hf0f0f0f0, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h050),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[12]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[6]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(64, 64'h0000000100000000, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h060),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (64),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[13]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[7]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(64, 64'hf0f0f0f0f0f0f0f0, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h070),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (64),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[14]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[8]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (0),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h080),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[15]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[9]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
        rggen_default_register #(
          .READABLE       (0),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h090),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[16]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[10]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h0000ffff, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h0a0+10'(32*(2*i+j))+10'h010+10'(4*(2*k+l))),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[17+4*(2*i+j)+2*k+l]),
          .bit_field_if (bit_field_if)
        );
      CODE

      expect(registers[11]).to generate_code(:register, :top_down, <<~'CODE')
        `rggen_tie_off_unused_signals(32, 32'h0000ffff, bit_field_if)
        rggen_default_register #(
          .READABLE       (1),
          .WRITABLE       (1),
          .ADDRESS_WIDTH  (10),
          .OFFSET_ADDRESS (10'h200+10'(32*i)+10'(8*j)),
          .BUS_WIDTH      (32),
          .DATA_WIDTH     (32),
          .VALUE_WIDTH    (64)
        ) u_register (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .register_if  (register_if[33+2*i+j]),
          .bit_field_if (bit_field_if)
        );
      CODE
    end
  end
end
