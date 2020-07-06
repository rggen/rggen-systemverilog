# frozen_string_literal: true

RSpec.describe 'register/sv_rtl_top' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format, :fold_sv_interface_port])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_registers(&body)
    create_sv_rtl(&body).registers
  end

  let(:bus_width) { default_configuration.bus_width }

  describe 'bit_field_if' do
    context 'レジスタがビットフィールドを持つ場合' do
      it 'rggen_bit_field_ifのインスタンスを持つ' do
        registers = create_registers do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register do
            name 'register_1'
            offset_address 0x10
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end

          register do
            name 'register_2'
            offset_address 0x20
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register do
            name 'register_3'
            offset_address 0x30
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end

          register do
            name 'register_4'
            offset_address 0x40
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register do
            name 'register_5'
            offset_address 0x50
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end
        end

        expect(registers[0]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [32]
        )
        expect(registers[1]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [64]
        )
        expect(registers[2]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [32]
        )
        expect(registers[3]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [64]
        )
        expect(registers[4]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [32]
        )
        expect(registers[5]).to have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [64]
        )
      end
    end

    context 'レジスタがビットフィールドを持たない場合' do
      it 'rggen_bit_field_ifのインスタンスを持たない' do
        registers = create_registers do
          name 'block_0'
          byte_size 256
          register do
            name 'register_0'
            offset_address 0x00
            size [64]
            type :external
          end
        end

        expect(registers[0]).to not_have_interface(
          :bit_field_if,
          name: 'bit_field_if', interface_type: 'rggen_bit_field_if', parameter_values: [32]
        )
      end
    end
  end

  describe '#generate_code' do
    it 'レジスタ階層のコードを出力する' do
      registers = create_registers do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x10
          type :external
          size [4]
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          offset_address 0x30
          type [:indirect, 'register_0.bit_field_0', 'register_0.bit_field_1']
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_4'
          offset_address 0x40
          bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          offset_address 0x50
          size [2, 2]
          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              offset_address 0x00
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(registers[0]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_0
          rggen_bit_field_if #(32) bit_field_if();
          rggen_default_register #(
            .READABLE       (1),
            .WRITABLE       (1),
            .ADDRESS_WIDTH  (8),
            .OFFSET_ADDRESS (8'h00),
            .BUS_WIDTH      (32),
            .DATA_WIDTH     (32),
            .VALID_BITS     (32'h00000303),
            .REGISTER_INDEX (0)
          ) u_register (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .register_if  (register_if[0]),
            .bit_field_if (bit_field_if)
          );
          if (1) begin : g_bit_field_0
            localparam bit [1:0] INITIAL_VALUE = 2'h0;
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 2)
            rggen_bit_field_rw_wo #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .WRITE_ONLY     (0),
              .WRITE_ONCE     (0)
            ) u_bit_field (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .bit_field_if (bit_field_sub_if),
              .o_value      (o_register_0_bit_field_0)
            );
          end
          if (1) begin : g_bit_field_1
            localparam bit [1:0] INITIAL_VALUE = 2'h0;
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 2)
            rggen_bit_field_rw_wo #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .WRITE_ONLY     (0),
              .WRITE_ONCE     (0)
            ) u_bit_field (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .bit_field_if (bit_field_sub_if),
              .o_value      (o_register_0_bit_field_1)
            );
          end
        end endgenerate
      CODE

      expect(registers[1]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_1
          rggen_external_register #(
            .ADDRESS_WIDTH  (8),
            .BUS_WIDTH      (32),
            .START_ADDRESS  (8'h10),
            .END_ADDRESS    (8'h1f)
          ) u_register (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .register_if  (register_if[1]),
            .bus_if       (register_1_bus_if)
          );
        end endgenerate
      CODE

      expect(registers[2]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_2
          genvar i;
          for (i = 0;i < 4;++i) begin : g
            rggen_bit_field_if #(32) bit_field_if();
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (8),
              .OFFSET_ADDRESS (8'h20),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32),
              .VALID_BITS     (32'h00000303),
              .REGISTER_INDEX (i)
            ) u_register (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .register_if  (register_if[2+i]),
              .bit_field_if (bit_field_if)
            );
            if (1) begin : g_bit_field_0
              localparam bit [1:0] INITIAL_VALUE = 2'h0;
              rggen_bit_field_if #(2) bit_field_sub_if();
              `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 2)
              rggen_bit_field_rw_wo #(
                .WIDTH          (2),
                .INITIAL_VALUE  (INITIAL_VALUE),
                .WRITE_ONLY     (0),
                .WRITE_ONCE     (0)
              ) u_bit_field (
                .i_clk        (i_clk),
                .i_rst_n      (i_rst_n),
                .bit_field_if (bit_field_sub_if),
                .o_value      (o_register_2_bit_field_0[i])
              );
            end
            if (1) begin : g_bit_field_1
              localparam bit [1:0] INITIAL_VALUE = 2'h0;
              rggen_bit_field_if #(2) bit_field_sub_if();
              `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 2)
              rggen_bit_field_rw_wo #(
                .WIDTH          (2),
                .INITIAL_VALUE  (INITIAL_VALUE),
                .WRITE_ONLY     (0),
                .WRITE_ONCE     (0)
              ) u_bit_field (
                .i_clk        (i_clk),
                .i_rst_n      (i_rst_n),
                .bit_field_if (bit_field_sub_if),
                .o_value      (o_register_2_bit_field_1[i])
              );
            end
          end
        end endgenerate
      CODE

      expect(registers[3]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_3
          genvar i;
          genvar j;
          for (i = 0;i < 2;++i) begin : g
            for (j = 0;j < 2;++j) begin : g
              logic [3:0] indirect_index;
              rggen_bit_field_if #(32) bit_field_if();
              assign indirect_index = {register_if[0].value[0+:2], register_if[0].value[8+:2]};
              rggen_indirect_register #(
                .READABLE             (1),
                .WRITABLE             (1),
                .ADDRESS_WIDTH        (8),
                .OFFSET_ADDRESS       (8'h30),
                .BUS_WIDTH            (32),
                .DATA_WIDTH           (32),
                .VALID_BITS           (32'h00000303),
                .INDIRECT_INDEX_WIDTH (4),
                .INDIRECT_INDEX_VALUE ({i[0+:2], j[0+:2]})
              ) u_register (
                .i_clk            (i_clk),
                .i_rst_n          (i_rst_n),
                .register_if      (register_if[6+2*i+j]),
                .i_indirect_index (indirect_index),
                .bit_field_if     (bit_field_if)
              );
              if (1) begin : g_bit_field_0
                localparam bit [1:0] INITIAL_VALUE = 2'h0;
                rggen_bit_field_if #(2) bit_field_sub_if();
                `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 2)
                rggen_bit_field_rw_wo #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (INITIAL_VALUE),
                  .WRITE_ONLY     (0),
                  .WRITE_ONCE     (0)
                ) u_bit_field (
                  .i_clk        (i_clk),
                  .i_rst_n      (i_rst_n),
                  .bit_field_if (bit_field_sub_if),
                  .o_value      (o_register_3_bit_field_0[i][j])
                );
              end
              if (1) begin : g_bit_field_1
                localparam bit [1:0] INITIAL_VALUE = 2'h0;
                rggen_bit_field_if #(2) bit_field_sub_if();
                `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 2)
                rggen_bit_field_rw_wo #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (INITIAL_VALUE),
                  .WRITE_ONLY     (0),
                  .WRITE_ONCE     (0)
                ) u_bit_field (
                  .i_clk        (i_clk),
                  .i_rst_n      (i_rst_n),
                  .bit_field_if (bit_field_sub_if),
                  .o_value      (o_register_3_bit_field_1[i][j])
                );
              end
            end
          end
        end endgenerate
      CODE

      expect(registers[4]).to generate_code(:register_file, :top_down, <<~'CODE')
        generate if (1) begin : g_register_4
          rggen_bit_field_if #(32) bit_field_if();
          rggen_default_register #(
            .READABLE       (1),
            .WRITABLE       (1),
            .ADDRESS_WIDTH  (8),
            .OFFSET_ADDRESS (8'h40),
            .BUS_WIDTH      (32),
            .DATA_WIDTH     (32),
            .VALID_BITS     (32'h00000003),
            .REGISTER_INDEX (0)
          ) u_register (
            .i_clk        (i_clk),
            .i_rst_n      (i_rst_n),
            .register_if  (register_if[10]),
            .bit_field_if (bit_field_if)
          );
          if (1) begin : g_register_4
            localparam bit [1:0] INITIAL_VALUE = 2'h0;
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 2)
            rggen_bit_field_rw_wo #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .WRITE_ONLY     (0),
              .WRITE_ONCE     (0)
            ) u_bit_field (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .bit_field_if (bit_field_sub_if),
              .o_value      (o_register_4)
            );
          end
        end endgenerate
      CODE

      expect(registers[5]).to generate_code(:register_file, :top_down, <<~'CODE')
        if (1) begin : g_register_0
          genvar k;
          genvar l;
          for (k = 0;k < 2;++k) begin : g
            for (l = 0;l < 2;++l) begin : g
              rggen_bit_field_if #(32) bit_field_if();
              rggen_default_register #(
                .READABLE       (1),
                .WRITABLE       (1),
                .ADDRESS_WIDTH  (8),
                .OFFSET_ADDRESS (8'h50+16*(2*i+j)),
                .BUS_WIDTH      (32),
                .DATA_WIDTH     (32),
                .VALID_BITS     (32'h00000003),
                .REGISTER_INDEX (2*k+l)
              ) u_register (
                .i_clk        (i_clk),
                .i_rst_n      (i_rst_n),
                .register_if  (register_if[11+4*(2*i+j)+2*k+l]),
                .bit_field_if (bit_field_if)
              );
              if (1) begin : g_bit_field_0
                localparam bit [1:0] INITIAL_VALUE = 2'h0;
                rggen_bit_field_if #(2) bit_field_sub_if();
                `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 2)
                rggen_bit_field_rw_wo #(
                  .WIDTH          (2),
                  .INITIAL_VALUE  (INITIAL_VALUE),
                  .WRITE_ONLY     (0),
                  .WRITE_ONCE     (0)
                ) u_bit_field (
                  .i_clk        (i_clk),
                  .i_rst_n      (i_rst_n),
                  .bit_field_if (bit_field_sub_if),
                  .o_value      (o_register_file_5_register_file_0_register_0_bit_field_0[i][j][k][l])
                );
              end
            end
          end
        end
      CODE
    end
  end
end
