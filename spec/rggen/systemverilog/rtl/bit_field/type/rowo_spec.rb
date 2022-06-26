# frozen_string_literal: true

RSpec.describe 'bit_field/type/rowo' do
  include_context 'clean-up builder'
  include_context 'bit field rtl common'

  before(:all) do
    RgGen.enable(:bit_field, :type, [:rowo, :rw])
  end

  it '出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :rowo; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, data_type: :logic, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
  end

  context '参照ビットフィールドを持たない場合' do
    it '入力ポート#value_inを持つ' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :rowo; initial_value 0 }
        end

        register do
          name 'register_2'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
        end

        register_file do
          name 'register_file_4'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_0', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[1]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_1', direction: :input, data_type: :logic, width: 2
      )
      expect(bit_fields[2]).to have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[3]).to have_port(
        :register_block, :value_in,
        name: 'i_register_1_bit_field_0', direction: :input, data_type: :logic, width: 64
      )

      expect(bit_fields[4]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[5]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[6]).to have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[7]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[8]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[9]).to have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[10]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )
      expect(bit_fields[11]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )
      expect(bit_fields[12]).to have_port(
        :register_block, :value_in,
        name: 'i_register_file_4_register_file_0_register_0_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2, 2, 2, 2, 2], array_format: array_port_format
      )
    end
  end

  context '参照ビットフィールドを持つ場合' do
    it '入力ポート#value_inを持たない' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0; reference 'register_5.bit_field_2' }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :rowo; initial_value 0; reference 'register_5.bit_field_3' }
        end

        register do
          name 'register_2'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0; reference 'register_5.bit_field_2' }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0; reference 'register_5.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0; reference 'register_5.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0; reference 'register_5.bit_field_2' }
        end

        register_file do
          name 'register_file_4'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0; reference 'register_5.bit_field_0' }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rowo; initial_value 0; reference 'register_5.bit_field_1' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :rowo; initial_value 0; reference 'register_5.bit_field_2' }
            end
          end
        end

        register do
          name 'register_5'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 32, width: 64; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_0', direction: :input, data_type: :logic, width: 1
      )
      expect(bit_fields[1]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_1', direction: :input, data_type: :logic, width: 2
      )
      expect(bit_fields[2]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_0_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[3]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_1_bit_field_0', direction: :input, data_type: :logic, width: 64
      )

      expect(bit_fields[4]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[5]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [4], array_format: array_port_format
      )
      expect(bit_fields[6]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_2_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [2, 2], array_format: array_port_format
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_3_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_0', direction: :input, data_type: :logic, width: 1,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )
      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_1', direction: :input, data_type: :logic, width: 2,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )
      expect(bit_fields[10]).to not_have_port(
        :register_block, :value_in,
        name: 'i_register_4_register_file_0_register_0_bit_field_2', direction: :input, data_type: :logic, width: 4,
        array_size: [2, 2, 2, 2, 2], array_format: array_port_format
      )
    end
  end

  describe '#generate_code' do
    let(:array_port_format) { :packed }

    it 'rggen_bit_fieldをインスタンスするコードを生成する' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :rowo; initial_value 0; reference 'register_1.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 8; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 16, width: 8; type :rowo; initial_value 0; reference 'register_1.bit_field_1' }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :rowo; initial_value 0 }
        end

        register do
          name 'register_3'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_4.bit_field_1' }
        end

        register do
          name 'register_4'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_5'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_6.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_7.bit_field_0' }
        end

        register do
          name 'register_6'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_7'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
        end

        register do
          name 'register_8'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_9.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_10.bit_field_0' }
        end

        register do
          name 'register_9'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_10'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_11'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_file_12.register_file_0.register_0.bit_field_0' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 2, step: 16; type :rowo; initial_value 0; reference 'register_file_12.register_file_0.register_1.bit_field_0' }
            end
          end
        end

        register_file do
          name 'register_file_12'
          size [2, 2]
          register_file do
            name 'register_file_0'

            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4, sequence_size: 2; type :rw; initial_value 0 }
            end

            register do
              name 'register_1'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 4, width: 4; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (1),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_0_bit_field_0),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (1),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[1].value[1+:1]),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (8),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_0_bit_field_2),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_2),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (8),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[1].value[16+:8]),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_3),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (64),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_2_bit_field_0),
          .i_mask             ('1),
          .o_value            (o_register_2_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[7]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_3_bit_field_0[i]),
          .i_mask             ('1),
          .o_value            (o_register_3_bit_field_0[i]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[4].value[4+:4]),
          .i_mask             ('1),
          .o_value            (o_register_3_bit_field_1[i]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[9]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[4].value[8+4*i+:4]),
          .i_mask             ('1),
          .o_value            (o_register_3_bit_field_2[i]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[12]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_5_bit_field_0[i][j]),
          .i_mask             ('1),
          .o_value            (o_register_5_bit_field_0[i][j]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[13]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[9+i].value[4+4*j+:4]),
          .i_mask             ('1),
          .o_value            (o_register_5_bit_field_1[i][j]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[14]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[13].value[4+:4]),
          .i_mask             ('1),
          .o_value            (o_register_5_bit_field_2[i][j]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[17]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_8_bit_field_0[i][j][k]),
          .i_mask             ('1),
          .o_value            (o_register_8_bit_field_0[i][j][k]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[18]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[18+2*i+j].value[4+4*k+:4]),
          .i_mask             ('1),
          .o_value            (o_register_8_bit_field_1[i][j][k]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[19]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[22].value[4+:4]),
          .i_mask             ('1),
          .o_value            (o_register_8_bit_field_2[i][j][k]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[22]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (i_register_file_11_register_file_0_register_0_bit_field_0[i][j][k][l][m]),
          .i_mask             ('1),
          .o_value            (o_register_file_11_register_file_0_register_0_bit_field_0[i][j][k][l][m]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[23]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[39+5*(2*i+j)+2*k+l].value[4+4*m+:4]),
          .i_mask             ('1),
          .o_value            (o_register_file_11_register_file_0_register_0_bit_field_1[i][j][k][l][m]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[24]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH              (4),
          .INITIAL_VALUE      (INITIAL_VALUE),
          .EXTERNAL_READ_DATA (1),
          .TRIGGER            (0)
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
          .i_value            (register_if[39+5*(2*i+j)+4].value[4+:4]),
          .i_mask             ('1),
          .o_value            (o_register_file_11_register_file_0_register_0_bit_field_2[i][j][k][l][m]),
          .o_value_unmasked   ()
        );
      CODE
    end
  end
end
