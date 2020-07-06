# frozen_string_literal: true

RSpec.describe 'bit_field/type/w0trg' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:w0trg])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  let(:bit_fields) do
    configuration = create_configuration(array_port_format: array_port_format)
    sv_rtl = create_sv_rtl(configuration) do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
      end

      register_file do
        name 'register_file_3'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :w0trg }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :w0trg }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :w0trg }
          end
        end
      end
    end
    sv_rtl.bit_fields
  end

  let(:array_port_format) do
    [:packed, :unpacked, :serialized].sample
  end

  it '出力ポート#triggerを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_0_trigger', direction: :output, data_type: :logic, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_1_trigger', direction: :output, data_type: :logic, width: 4
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :trigger,
      name: 'o_register_0_bit_field_2_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_0_trigger', direction: :output, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_1_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :trigger,
      name: 'o_register_1_bit_field_2_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_0_trigger', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_1_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :trigger,
      name: 'o_register_2_bit_field_2_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_0_trigger', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_1_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :trigger,
      name: 'o_register_file_3_register_file_0_register_0_bit_field_2_trigger', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
  end

  describe '#generate_code' do
    let(:array_port_format) { :packed }

    it 'rggen_bit_field_w01trgをインスタンスするコードを生成する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (1)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_0_bit_field_0_trigger)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_0_bit_field_1_trigger)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_0_bit_field_2_trigger[i])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_1_bit_field_2_trigger[i][j])
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_2_bit_field_2_trigger[i][j][k])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_w01trg #(
          .TRIGGER_VALUE  (1'b0),
          .WIDTH          (4)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .o_trigger    (o_register_file_3_register_file_0_register_0_bit_field_2_trigger[i][j][k][l][m])
        );
      CODE
    end
  end
end
