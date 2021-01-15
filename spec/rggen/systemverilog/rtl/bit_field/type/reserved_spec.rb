# frozen_string_literal: true

RSpec.describe 'bit_field/type/reserved' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:reserved, :rw])
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_bit_fields(&body)
    create_sv_rtl(&body).bit_fields
  end

  describe '#generate_code' do
    it 'rggen_bit_fieldをインスタンスするコードを出力する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :reserved }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 16; type :reserved }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :reserved }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'regsiter_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :reserved }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (1),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (16),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (64),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH          (4),
          .SW_READ_ACTION (RGGEN_READ_NONE),
          .STORAGE        (0)
        ) u_bit_field (
          .i_clk              ('0),
          .i_rst_n            ('1),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('0),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           ('0),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('0),
          .o_value            (),
          .o_value_unmasked   ()
        );
      CODE
    end
  end
end
