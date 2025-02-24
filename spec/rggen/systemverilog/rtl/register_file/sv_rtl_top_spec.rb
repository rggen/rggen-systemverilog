# frozen_string_literal: true

RSpec.describe 'register_file/sv_rtl_top' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size, :bus_width])
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

  def create_register_files(&body)
    create_sv_rtl(&body).register_blocks[0].register_files(false)
  end

  describe '#generate_code' do
    it 'レジスタファイル階層のコードを出力する' do
      register_files = create_register_files do
        name 'block_0'
        byte_size 512

        register_file do
          name 'register_file_0'
          offset_address 0x00
          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          offset_address 0x10

          register_file do
            name 'register_file_0'
            offset_address 0x00
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_2'
          offset_address 0x20
          size [2, 2]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_3'
          offset_address 0xA0
          size [2, step: 64]

          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, step: 8]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
            end
          end

          register do
            name 'register_1'
            size [2, step: 8]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      expect(register_files[0]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_0
          if (1) begin : g_register_0
            rggen_bit_field_if #(32) bit_field_if();
            `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h000),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32),
              .VALUE_WIDTH    (32)
            ) u_register (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .register_if  (register_if[0]),
              .bit_field_if (bit_field_if)
            );
            if (1) begin : g_bit_field_0
              localparam bit INITIAL_VALUE = 1'h0;
              rggen_bit_field_if #(1) bit_field_sub_if();
              `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
              rggen_bit_field #(
                .WIDTH          (1),
                .INITIAL_VALUE  (INITIAL_VALUE),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .bit_field_if       (bit_field_sub_if),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_sw_write_enable  ('1),
                .i_hw_write_enable  ('0),
                .i_hw_write_data    ('0),
                .i_hw_set           ('0),
                .i_hw_clear         ('0),
                .i_value            ('0),
                .i_mask             ('1),
                .o_value            (o_register_file_0_register_0_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
          if (1) begin : g_register_1
            rggen_bit_field_if #(32) bit_field_if();
            `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h004),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32),
              .VALUE_WIDTH    (32)
            ) u_register (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .register_if  (register_if[1]),
              .bit_field_if (bit_field_if)
            );
            if (1) begin : g_bit_field_0
              localparam bit INITIAL_VALUE = 1'h0;
              rggen_bit_field_if #(1) bit_field_sub_if();
              `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
              rggen_bit_field #(
                .WIDTH          (1),
                .INITIAL_VALUE  (INITIAL_VALUE),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .bit_field_if       (bit_field_sub_if),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_sw_write_enable  ('1),
                .i_hw_write_enable  ('0),
                .i_hw_write_data    ('0),
                .i_hw_set           ('0),
                .i_hw_clear         ('0),
                .i_value            ('0),
                .i_mask             ('1),
                .o_value            (o_register_file_0_register_1_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
        end endgenerate
      CODE

      expect(register_files[1]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_1
          if (1) begin : g_register_file_0
            if (1) begin : g_register_0
              rggen_bit_field_if #(32) bit_field_if();
              `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
              rggen_default_register #(
                .READABLE       (1),
                .WRITABLE       (1),
                .ADDRESS_WIDTH  (9),
                .OFFSET_ADDRESS (9'h010),
                .BUS_WIDTH      (32),
                .DATA_WIDTH     (32),
                .VALUE_WIDTH    (32)
              ) u_register (
                .i_clk        (i_clk),
                .i_rst_n      (i_rst_n),
                .register_if  (register_if[2]),
                .bit_field_if (bit_field_if)
              );
              if (1) begin : g_bit_field_0
                localparam bit INITIAL_VALUE = 1'h0;
                rggen_bit_field_if #(1) bit_field_sub_if();
                `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
                rggen_bit_field #(
                  .WIDTH          (1),
                  .INITIAL_VALUE  (INITIAL_VALUE),
                  .SW_WRITE_ONCE  (0),
                  .TRIGGER        (0)
                ) u_bit_field (
                  .i_clk              (i_clk),
                  .i_rst_n            (i_rst_n),
                  .bit_field_if       (bit_field_sub_if),
                  .o_write_trigger    (),
                  .o_read_trigger     (),
                  .i_sw_write_enable  ('1),
                  .i_hw_write_enable  ('0),
                  .i_hw_write_data    ('0),
                  .i_hw_set           ('0),
                  .i_hw_clear         ('0),
                  .i_value            ('0),
                  .i_mask             ('1),
                  .o_value            (o_register_file_1_register_file_0_register_0_bit_field_0),
                  .o_value_unmasked   ()
                );
              end
            end
          end
          if (1) begin : g_register_1
            rggen_bit_field_if #(32) bit_field_if();
            `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
            rggen_default_register #(
              .READABLE       (1),
              .WRITABLE       (1),
              .ADDRESS_WIDTH  (9),
              .OFFSET_ADDRESS (9'h014),
              .BUS_WIDTH      (32),
              .DATA_WIDTH     (32),
              .VALUE_WIDTH    (32)
            ) u_register (
              .i_clk        (i_clk),
              .i_rst_n      (i_rst_n),
              .register_if  (register_if[3]),
              .bit_field_if (bit_field_if)
            );
            if (1) begin : g_bit_field_0
              localparam bit INITIAL_VALUE = 1'h0;
              rggen_bit_field_if #(1) bit_field_sub_if();
              `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
              rggen_bit_field #(
                .WIDTH          (1),
                .INITIAL_VALUE  (INITIAL_VALUE),
                .SW_WRITE_ONCE  (0),
                .TRIGGER        (0)
              ) u_bit_field (
                .i_clk              (i_clk),
                .i_rst_n            (i_rst_n),
                .bit_field_if       (bit_field_sub_if),
                .o_write_trigger    (),
                .o_read_trigger     (),
                .i_sw_write_enable  ('1),
                .i_hw_write_enable  ('0),
                .i_hw_write_data    ('0),
                .i_hw_set           ('0),
                .i_hw_clear         ('0),
                .i_value            ('0),
                .i_mask             ('1),
                .o_value            (o_register_file_1_register_1_bit_field_0),
                .o_value_unmasked   ()
              );
            end
          end
        end endgenerate
      CODE

      expect(register_files[2]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_2
          genvar i;
          genvar j;
          for (i = 0;i < 2;++i) begin : g
            for (j = 0;j < 2;++j) begin : g
              if (1) begin : g_register_file_0
                if (1) begin : g_register_0
                  genvar k;
                  genvar l;
                  for (k = 0;k < 2;++k) begin : g
                    for (l = 0;l < 2;++l) begin : g
                      rggen_bit_field_if #(32) bit_field_if();
                      `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
                      rggen_default_register #(
                        .READABLE       (1),
                        .WRITABLE       (1),
                        .ADDRESS_WIDTH  (9),
                        .OFFSET_ADDRESS (9'h020+9'(32*(2*i+j))+9'(4*(2*k+l))),
                        .BUS_WIDTH      (32),
                        .DATA_WIDTH     (32),
                        .VALUE_WIDTH    (32)
                      ) u_register (
                        .i_clk        (i_clk),
                        .i_rst_n      (i_rst_n),
                        .register_if  (register_if[4+8*(2*i+j)+2*k+l]),
                        .bit_field_if (bit_field_if)
                      );
                      if (1) begin : g_bit_field_0
                        localparam bit INITIAL_VALUE = 1'h0;
                        rggen_bit_field_if #(1) bit_field_sub_if();
                        `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
                        rggen_bit_field #(
                          .WIDTH          (1),
                          .INITIAL_VALUE  (INITIAL_VALUE),
                          .SW_WRITE_ONCE  (0),
                          .TRIGGER        (0)
                        ) u_bit_field (
                          .i_clk              (i_clk),
                          .i_rst_n            (i_rst_n),
                          .bit_field_if       (bit_field_sub_if),
                          .o_write_trigger    (),
                          .o_read_trigger     (),
                          .i_sw_write_enable  ('1),
                          .i_hw_write_enable  ('0),
                          .i_hw_write_data    ('0),
                          .i_hw_set           ('0),
                          .i_hw_clear         ('0),
                          .i_value            ('0),
                          .i_mask             ('1),
                          .o_value            (o_register_file_2_register_file_0_register_0_bit_field_0[i][j][k][l]),
                          .o_value_unmasked   ()
                        );
                      end
                    end
                  end
                end
              end
              if (1) begin : g_register_1
                genvar k;
                genvar l;
                for (k = 0;k < 2;++k) begin : g
                  for (l = 0;l < 2;++l) begin : g
                    rggen_bit_field_if #(32) bit_field_if();
                    `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
                    rggen_default_register #(
                      .READABLE       (1),
                      .WRITABLE       (1),
                      .ADDRESS_WIDTH  (9),
                      .OFFSET_ADDRESS (9'h020+9'(32*(2*i+j))+9'h010+9'(4*(2*k+l))),
                      .BUS_WIDTH      (32),
                      .DATA_WIDTH     (32),
                      .VALUE_WIDTH    (32)
                    ) u_register (
                      .i_clk        (i_clk),
                      .i_rst_n      (i_rst_n),
                      .register_if  (register_if[4+8*(2*i+j)+4+2*k+l]),
                      .bit_field_if (bit_field_if)
                    );
                    if (1) begin : g_bit_field_0
                      localparam bit INITIAL_VALUE = 1'h0;
                      rggen_bit_field_if #(1) bit_field_sub_if();
                      `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
                      rggen_bit_field #(
                        .WIDTH          (1),
                        .INITIAL_VALUE  (INITIAL_VALUE),
                        .SW_WRITE_ONCE  (0),
                        .TRIGGER        (0)
                      ) u_bit_field (
                        .i_clk              (i_clk),
                        .i_rst_n            (i_rst_n),
                        .bit_field_if       (bit_field_sub_if),
                        .o_write_trigger    (),
                        .o_read_trigger     (),
                        .i_sw_write_enable  ('1),
                        .i_hw_write_enable  ('0),
                        .i_hw_write_data    ('0),
                        .i_hw_set           ('0),
                        .i_hw_clear         ('0),
                        .i_value            ('0),
                        .i_mask             ('1),
                        .o_value            (o_register_file_2_register_1_bit_field_0[i][j][k][l]),
                        .o_value_unmasked   ()
                      );
                    end
                  end
                end
              end
            end
          end
        end endgenerate
      CODE

      expect(register_files[3]).to generate_code(:register_file, :top_down, 0, <<~'CODE')
        generate if (1) begin : g_register_file_3
          genvar i;
          for (i = 0;i < 2;++i) begin : g
            if (1) begin : g_register_file_0
              if (1) begin : g_register_0
                genvar j;
                for (j = 0;j < 2;++j) begin : g
                  rggen_bit_field_if #(32) bit_field_if();
                  `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
                  rggen_default_register #(
                    .READABLE       (1),
                    .WRITABLE       (1),
                    .ADDRESS_WIDTH  (9),
                    .OFFSET_ADDRESS (9'h0a0+9'(64*i)+9'(8*j)),
                    .BUS_WIDTH      (32),
                    .DATA_WIDTH     (32),
                    .VALUE_WIDTH    (32)
                  ) u_register (
                    .i_clk        (i_clk),
                    .i_rst_n      (i_rst_n),
                    .register_if  (register_if[36+4*i+j]),
                    .bit_field_if (bit_field_if)
                  );
                  if (1) begin : g_bit_field_0
                    localparam bit INITIAL_VALUE = 1'h0;
                    rggen_bit_field_if #(1) bit_field_sub_if();
                    `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
                    rggen_bit_field #(
                      .WIDTH          (1),
                      .INITIAL_VALUE  (INITIAL_VALUE),
                      .SW_WRITE_ONCE  (0),
                      .TRIGGER        (0)
                    ) u_bit_field (
                      .i_clk              (i_clk),
                      .i_rst_n            (i_rst_n),
                      .bit_field_if       (bit_field_sub_if),
                      .o_write_trigger    (),
                      .o_read_trigger     (),
                      .i_sw_write_enable  ('1),
                      .i_hw_write_enable  ('0),
                      .i_hw_write_data    ('0),
                      .i_hw_set           ('0),
                      .i_hw_clear         ('0),
                      .i_value            ('0),
                      .i_mask             ('1),
                      .o_value            (o_register_file_3_register_file_0_register_0_bit_field_0[i][j]),
                      .o_value_unmasked   ()
                    );
                  end
                end
              end
            end
            if (1) begin : g_register_1
              genvar j;
              for (j = 0;j < 2;++j) begin : g
                rggen_bit_field_if #(32) bit_field_if();
                `rggen_tie_off_unused_signals(32, 32'h00000001, bit_field_if)
                rggen_default_register #(
                  .READABLE       (1),
                  .WRITABLE       (1),
                  .ADDRESS_WIDTH  (9),
                  .OFFSET_ADDRESS (9'h0a0+9'(64*i)+9'h010+9'(8*j)),
                  .BUS_WIDTH      (32),
                  .DATA_WIDTH     (32),
                  .VALUE_WIDTH    (32)
                ) u_register (
                  .i_clk        (i_clk),
                  .i_rst_n      (i_rst_n),
                  .register_if  (register_if[36+4*i+2+j]),
                  .bit_field_if (bit_field_if)
                );
                if (1) begin : g_bit_field_0
                  localparam bit INITIAL_VALUE = 1'h0;
                  rggen_bit_field_if #(1) bit_field_sub_if();
                  `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
                  rggen_bit_field #(
                    .WIDTH          (1),
                    .INITIAL_VALUE  (INITIAL_VALUE),
                    .SW_WRITE_ONCE  (0),
                    .TRIGGER        (0)
                  ) u_bit_field (
                    .i_clk              (i_clk),
                    .i_rst_n            (i_rst_n),
                    .bit_field_if       (bit_field_sub_if),
                    .o_write_trigger    (),
                    .o_read_trigger     (),
                    .i_sw_write_enable  ('1),
                    .i_hw_write_enable  ('0),
                    .i_hw_write_data    ('0),
                    .i_hw_set           ('0),
                    .i_hw_clear         ('0),
                    .i_value            ('0),
                    .i_mask             ('1),
                    .o_value            (o_register_file_3_register_1_bit_field_0[i][j]),
                    .o_value_unmasked   ()
                  );
                end
              end
            end
          end
        end endgenerate
      CODE
    end
  end
end
