# frozen_string_literal: true

RSpec.describe 'bit_field/type/wc' do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, :byte_size)
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :type, :offset_address])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:wc, :rw])
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_bit_fields(&body)
    configuration = create_configuration(array_port_format: array_port_format)
    create_sv_rtl(configuration, &body).bit_fields
  end

  let(:array_port_format) do
    [:packed, :unpacked, :serialized].sample
  end

  it '入力ポート#set/出力ポート#value_outを持つ' do
    bit_fields = create_bit_fields do
      byte_size 256

      register do
        name 'register_0'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
      end

      register do
        name 'register_1'
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wc; initial_value 0 }
      end

      register do
        name 'register_2'
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
      end

      register do
        name 'register_3'
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
          end
        end
      end
    end

    expect(bit_fields[0]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_0_set', direction: :input, data_type: :logic, width: 1
    )
    expect(bit_fields[0]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1
    )

    expect(bit_fields[1]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_1_set', direction: :input, data_type: :logic, width: 2
    )
    expect(bit_fields[1]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2
    )

    expect(bit_fields[2]).to have_port(
      :register_block, :set,
      name: 'i_register_0_bit_field_2_set', direction: :input, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )
    expect(bit_fields[2]).to have_port(
      :register_block, :value_out,
      name: 'o_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2], array_format: array_port_format
    )

    expect(bit_fields[3]).to have_port(
      :register_block, :set,
      name: 'i_register_1_bit_field_0_set', direction: :input, data_type: :logic, width: 64
    )
    expect(bit_fields[3]).to have_port(
      :register_block, :value_out,
      name: 'o_register_1_bit_field_0', direction: :output, data_type: :logic, width: 64
    )

    expect(bit_fields[4]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_0_set', direction: :input, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[4]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[5]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_1_set', direction: :input, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )
    expect(bit_fields[5]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [4], array_format: array_port_format
    )

    expect(bit_fields[6]).to have_port(
      :register_block, :set,
      name: 'i_register_2_bit_field_2_set', direction: :input, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )
    expect(bit_fields[6]).to have_port(
      :register_block, :value_out,
      name: 'o_register_2_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [4, 2], array_format: array_port_format
    )

    expect(bit_fields[7]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_0_set', direction: :input, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[7]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[8]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_1_set', direction: :input, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )
    expect(bit_fields[8]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2], array_format: array_port_format
    )

    expect(bit_fields[9]).to have_port(
      :register_block, :set,
      name: 'i_register_3_bit_field_2_set', direction: :input, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[9]).to have_port(
      :register_block, :value_out,
      name: 'o_register_3_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[10]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_0_set', direction: :input, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[10]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_0', direction: :output, data_type: :logic, width: 1,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[11]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_1_set', direction: :input, data_type: :logic, width: 2,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[11]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_1', direction: :output, data_type: :logic, width: 2,
      array_size: [2, 2, 2, 2], array_format: array_port_format
    )

    expect(bit_fields[12]).to have_port(
      :register_block, :set,
      name: 'i_register_file_4_register_file_0_register_0_bit_field_2_set', direction: :input, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
    expect(bit_fields[12]).to have_port(
      :register_block, :value_out,
      name: 'o_register_file_4_register_file_0_register_0_bit_field_2', direction: :output, data_type: :logic, width: 4,
      array_size: [2, 2, 2, 2, 2], array_format: array_port_format
    )
  end

  context '参照信号を持つ場合' do
    it '出力ポート#value_unmaskedを持つ' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0; reference 'register_4.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0; reference 'register_4.bit_field_1' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0; reference 'register_4.bit_field_2' }
        end

        register_file do
          name 'register_file_3'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0; reference 'register_4.bit_field_0' }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0; reference 'register_4.bit_field_1' }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0; reference 'register_4.bit_field_2' }
            end
          end
        end

        register do
          name 'register_4'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1
      )

      expect(bit_fields[1]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2
      )

      expect(bit_fields[2]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[3]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )

      expect(bit_fields[4]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [4], array_format: array_port_format
      )

      expect(bit_fields[5]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[6]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )

      expect(bit_fields[7]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [2, 2], array_format: array_port_format
      )

      expect(bit_fields[8]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[9]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[10]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[11]).to have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [2, 2, 2, 2, 2], array_format: array_port_format
      )
    end
  end

  context '参照信号を持たない場合' do
    it '出力ポート#value_unmaskedを持たない' do
      bit_fields = create_bit_fields do
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
        end

        register_file do
          name 'register_file_3'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :wc; initial_value 0 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4, sequence_size: 2, step: 8; type :wc; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1
      )

      expect(bit_fields[1]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2
      )

      expect(bit_fields[2]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_0_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [2], array_format: array_port_format
      )

      expect(bit_fields[3]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [4], array_format: array_port_format
      )

      expect(bit_fields[4]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [4], array_format: array_port_format
      )

      expect(bit_fields[5]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_1_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [4, 2], array_format: array_port_format
      )

      expect(bit_fields[6]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [2, 2], array_format: array_port_format
      )

      expect(bit_fields[7]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [2, 2], array_format: array_port_format
      )

      expect(bit_fields[8]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_2_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
        array_size: [2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[9]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_0_unmasked', direction: :output, data_type: :logic, width: 1,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[10]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_1_unmasked', direction: :output, data_type: :logic, width: 2,
        array_size: [2, 2, 2, 2], array_format: array_port_format
      )

      expect(bit_fields[11]).to not_have_port(
        :register_block, :value_unmasked,
        name: 'o_register_file_3_register_file_0_register_0_bit_field_2_unmasked', direction: :output, data_type: :logic, width: 4,
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
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :wc; reference 'register_6.bit_field_0'; initial_value 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 8; type :wc; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 16, width: 8; type :wc; reference 'register_6.bit_field_2'; initial_value 0xab }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 64; type :wc; initial_value 0 }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :wc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register do
          name 'register_3'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :wc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register do
          name 'register_4'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wc; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :wc; reference 'register_6.bit_field_1'; initial_value 0 }
        end

        register_file do
          name 'register_file_5'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :wc; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :wc; reference 'register_file_7.register_file_0.register_0.bit_field_0'; initial_value 0 }
            end
          end
        end

        register do
          name 'register_6'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_7'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 8, width: 4; type :rw; initial_value 0 }
            end
          end
        end
      end

      expect(bit_fields[0]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_0_bit_field_0_set),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[1]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (1),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_0_bit_field_1_set),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[27].value[0+:1]),
          .o_value            (o_register_0_bit_field_1),
          .o_value_unmasked   (o_register_0_bit_field_1_unmasked)
        );
      CODE

      expect(bit_fields[2]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (8),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_0_bit_field_2_set),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_0_bit_field_2),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[3]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (8),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_0_bit_field_3_set),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[27].value[16+:8]),
          .o_value            (o_register_0_bit_field_3),
          .o_value_unmasked   (o_register_0_bit_field_3_unmasked)
        );
      CODE

      expect(bit_fields[4]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (64),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_1_bit_field_0_set),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_1_bit_field_0),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[5]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_2_bit_field_0_set[i]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_2_bit_field_0[i]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[6]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_2_bit_field_1_set[i]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[27].value[8+:4]),
          .o_value            (o_register_2_bit_field_1[i]),
          .o_value_unmasked   (o_register_2_bit_field_1_unmasked[i])
        );
      CODE

      expect(bit_fields[7]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_3_bit_field_0_set[i][j]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_3_bit_field_0[i][j]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[8]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_3_bit_field_1_set[i][j]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[27].value[8+:4]),
          .o_value            (o_register_3_bit_field_1[i][j]),
          .o_value_unmasked   (o_register_3_bit_field_1_unmasked[i][j])
        );
      CODE

      expect(bit_fields[9]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_4_bit_field_0_set[i][j][k]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_4_bit_field_0[i][j][k]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[10]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_4_bit_field_1_set[i][j][k]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[27].value[8+:4]),
          .o_value            (o_register_4_bit_field_1[i][j][k]),
          .o_value_unmasked   (o_register_4_bit_field_1_unmasked[i][j][k])
        );
      CODE

      expect(bit_fields[11]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_file_5_register_file_0_register_0_bit_field_0_set[i][j][k][l][m]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             ('1),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_0[i][j][k][l][m]),
          .o_value_unmasked   ()
        );
      CODE

      expect(bit_fields[12]).to generate_code(:bit_field, :top_down, <<~'CODE')
        rggen_bit_field #(
          .WIDTH            (4),
          .INITIAL_VALUE    (INITIAL_VALUE),
          .SW_READ_ACTION   (RGGEN_READ_DEFAULT),
          .SW_WRITE_ACTION  (RGGEN_WRITE_CLEAR)
        ) u_bit_field (
          .i_clk              (i_clk),
          .i_rst_n            (i_rst_n),
          .bit_field_if       (bit_field_sub_if),
          .i_sw_write_enable  ('1),
          .i_hw_write_enable  ('0),
          .i_hw_write_data    ('0),
          .i_hw_set           (i_register_file_5_register_file_0_register_0_bit_field_1_set[i][j][k][l][m]),
          .i_hw_clear         ('0),
          .i_value            ('0),
          .i_mask             (register_if[28+2*i+j].value[8+:4]),
          .o_value            (o_register_file_5_register_file_0_register_0_bit_field_1[i][j][k][l][m]),
          .o_value_unmasked   (o_register_file_5_register_file_0_register_0_bit_field_1_unmasked[i][j][k][l][m])
        );
      CODE
    end
  end
end
