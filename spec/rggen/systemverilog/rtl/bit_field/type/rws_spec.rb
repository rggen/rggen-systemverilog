# frozen_string_literal: true

RSpec.describe 'bit_field/type/rws' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:rw, :rws])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_bit_fields(&body)
    configuration = create_configuration(array_port_format: array_port_format)
    create_sv_rtl(configuration, &body).bit_fields
  end

  let(:bit_fields) do
    create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rws; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rws; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
      end

      register do
        name 'register_1'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rws; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rws; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
      end

      register do
        name 'register_2'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rws; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 1, width: 1; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 4, width: 2; type :rws; initial_value 0 }
        bit_field { name 'bit_field_3'; bit_assignment lsb: 6, width: 2; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
        bit_field { name 'bit_field_4'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0 }
        bit_field { name 'bit_field_5'; bit_assignment lsb: 20, width: 4, sequence_size: 2, step: 8; type :rws; initial_value 0; reference 'register_3.bit_field_0' }
      end

      register do
        name 'register_3'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end
    end
  end

  let(:array_port_format) do
    [:packed, :unpacked, :serialized].sample
  end

  it '入力ポート#value_in/出力ポート#value_outを持つ' do
    expect(bit_fields[0]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_0', direction: :input, data_type: :logic, width: 1
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_2', direction: :input, data_type: :logic, width: 2
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, data_type: :logic, width: 2
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_in,
      name: 'i_register_0_bit_field_4', direction: :input, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_4', direction: :output, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_0', direction: :input, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[8]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_2', direction: :input, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_2', direction: :output, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_in,
      name: 'i_register_1_bit_field_4', direction: :input, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_4', direction: :output, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_0', direction: :input, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[14]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_2', direction: :input, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[14]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[16]).to have_port(
      :register_block, :value_in,
      name: 'i_register_2_bit_field_4', direction: :input, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[16]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_4', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )
  end

  context '参照ビットフィールドを持たない場合' do
    it '入力ポート#setを持つ' do
      expect(bit_fields[0]).to have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_0_set', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[2]).to have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_2_set', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[4]).to have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_4_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[6]).to have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_0_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[8]).to have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_2_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[10]).to have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_4_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[12]).to have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_0_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[14]).to have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_2_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[16]).to have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_4_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2, 2], array_format: array_port_format
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it '入力ポート#setを持たない' do
      expect(bit_fields[1]).to not_have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_1_set', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[3]).to not_have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_3_set', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[5]).to not_have_port(
        :register_block, :set,
        name: 'i_register_0_bit_field_5_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_1_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_3_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[11]).to not_have_port(
        :register_block, :set,
        name: 'i_register_1_bit_field_5_set', direction: :input, data_type: :logic, width: 1,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[13]).to not_have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_1_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[15]).to not_have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_3_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[17]).to not_have_port(
        :register_block, :set,
        name: 'i_register_2_bit_field_5_set', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2, 2], array_format: array_port_format
      )
    end
  end

  describe '#generate_code' do
    let(:array_port_format) { :packed }

    it 'rggen_bit_field_rwsをインスタンスするコードを出力する' do
      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (1),
          .INITIAL_VALUE  (1'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (i_register_0_bit_field_0_set),
          .i_value      (i_register_0_bit_field_0),
          .o_value      (o_register_0_bit_field_0)
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (1),
          .INITIAL_VALUE  (1'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (register_if[9].value[0+:1]),
          .i_value      (i_register_0_bit_field_1),
          .o_value      (o_register_0_bit_field_1)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (2),
          .INITIAL_VALUE  (2'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (i_register_0_bit_field_2_set),
          .i_value      (i_register_0_bit_field_2),
          .o_value      (o_register_0_bit_field_2)
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (2),
          .INITIAL_VALUE  (2'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (register_if[9].value[0+:1]),
          .i_value      (i_register_0_bit_field_3),
          .o_value      (o_register_0_bit_field_3)
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (i_register_0_bit_field_4_set[i]),
          .i_value      (i_register_0_bit_field_4[i]),
          .o_value      (o_register_0_bit_field_4[i])
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (register_if[9].value[0+:1]),
          .i_value      (i_register_0_bit_field_5[i]),
          .o_value      (o_register_0_bit_field_5[i])
        );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (i_register_1_bit_field_4_set[i][j]),
          .i_value      (i_register_1_bit_field_4[i][j]),
          .o_value      (o_register_1_bit_field_4[i][j])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (register_if[9].value[0+:1]),
          .i_value      (i_register_1_bit_field_5[i][j]),
          .o_value      (o_register_1_bit_field_5[i][j])
        );
      CODE

      expect(bit_fields[16]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (i_register_2_bit_field_4_set[i][j][k]),
          .i_value      (i_register_2_bit_field_4[i][j][k]),
          .o_value      (o_register_2_bit_field_4[i][j][k])
        );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field_rws #(
          .WIDTH          (4),
          .INITIAL_VALUE  (4'h0)
        ) u_bit_field (
          .i_clk        (i_clk),
          .i_rst_n      (i_rst_n),
          .bit_field_if (bit_field_sub_if),
          .i_set        (register_if[9].value[0+:1]),
          .i_value      (i_register_2_bit_field_5[i][j][k]),
          .o_value      (o_register_2_bit_field_5[i][j][k])
        );
      CODE
    end
  end
end
