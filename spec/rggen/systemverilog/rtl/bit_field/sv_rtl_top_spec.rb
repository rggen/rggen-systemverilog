# frozen_string_literal: true

RSpec.describe 'bit_field/sv_rtl_top' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, :rw)
    RgGen.enable(:register_block, :sv_rtl_top)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_bit_fields(array_port_format = :packed, &body)
    configuration = create_configuration(array_port_format: array_port_format)
    create_sv_rtl(configuration, &body).bit_fields
  end

  describe '#initial_value' do
    context '単一の初期値が指定されている場合' do
      let(:array_port_format) { [:packed, :unpacked, :serialized].sample }

      it '局所パラメータinitial_valueを持つ' do
        bit_fields = create_bit_fields(array_port_format) do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 2 }
            end
          end
        end

        expect(bit_fields[0]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[1]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[2]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h02"
        )

        expect(bit_fields[3]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[4]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[5]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h02"
        )

        expect(bit_fields[6]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[7]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[8]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h02"
        )

        expect(bit_fields[9]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[10]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[11]).to have_parameter(
          :initial_value,
          name: 'INITIAL_VALUE', parameter_type: :localparam,
          data_type: :bit, width: 8, default: "8'h02"
        )
      end
    end

    context 'パラメータ化された初期値が指定されている場合' do
      let(:register_map_body) do
        proc do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value default: 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value default: 1 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value default: 2 }
            end
          end
        end
      end

      it 'パラメータinitial_valueを持つ' do
        bit_fields = create_bit_fields(:packed, &register_map_body)
        expect(bit_fields[0]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[1]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[2]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :packed, default: "{2{8'h02}}"
        )
        expect(bit_fields[3]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[4]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[5]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :packed, default: "{2{8'h02}}"
        )
        expect(bit_fields[6]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[7]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[8]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :packed, default: "{2{8'h02}}"
        )
        expect(bit_fields[9]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[10]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[11]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :packed, default: "{2{8'h02}}"
        )

        bit_fields = create_bit_fields(:unpacked, &register_map_body)
        expect(bit_fields[0]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[1]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[2]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{default: 8'h02}"
        )
        expect(bit_fields[3]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[4]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[5]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{default: 8'h02}"
        )
        expect(bit_fields[6]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[7]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[8]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{default: 8'h02}"
        )
        expect(bit_fields[9]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[10]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[11]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{default: 8'h02}"
        )

        bit_fields = create_bit_fields(:serialized, &register_map_body)
        expect(bit_fields[0]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[1]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[2]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
        )
        expect(bit_fields[3]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[4]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[5]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_1_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
        )
        expect(bit_fields[6]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[7]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[8]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_2_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
        )
        expect(bit_fields[9]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_0_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 1, default: "1'h0"
        )
        expect(bit_fields[10]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_1_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, default: "8'h01"
        )
        expect(bit_fields[11]).to have_parameter(
          :register_block, :initial_value,
          name: "REGISTER_FILE_3_REGISTER_0_BIT_FIELD_2_INITIAL_VALUE", parameter_type: :parameter,
          data_type: :bit, width: 8, array_size: [2], array_format: :serialized, default: "{2{8'h02}}"
        )
      end
    end

    context '配列化された初期値が指定されている場合' do
      let(:array_port_format) { [:packed, :unpacked, :serialized].sample }

      it '局所パラメータinitial_valueを持つ' do
        bit_fields = create_bit_fields(array_port_format) do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register do
            name 'register_1'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
          end

          register_file do
            name 'register_file_2'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end

          register_file do
            name 'register_file_3'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 8, sequence_size: 1; type :rw; initial_value [0] }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value [1, 2] }
            end
          end
        end

        expect(bit_fields[0]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [1], array_format: :unpacked, default: "'{8'h00}"
        )
        expect(bit_fields[1]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h01, 8'h02}"
        )
        expect(bit_fields[2]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [1], array_format: :unpacked, default: "'{8'h00}"
        )
        expect(bit_fields[3]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h01, 8'h02}"
        )
        expect(bit_fields[4]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [1], array_format: :unpacked, default: "'{8'h00}"
        )
        expect(bit_fields[5]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h01, 8'h02}"
        )
        expect(bit_fields[6]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [1], array_format: :unpacked, default: "'{8'h00}"
        )
        expect(bit_fields[7]).to have_parameter(
          :initial_value,
          name: "INITIAL_VALUE", parameter_type: :localparam,
          data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h01, 8'h02}"
        )
      end
    end
  end

  describe '#bit_field_sub_if' do
    it 'rggen_bit_field_ifのインスタンスを持つ' do
      bit_fields = create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 8, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 32, width: 64; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to have_interface(
        :bit_field_sub_if,
        name: 'bit_field_sub_if', interface_type: 'rggen_bit_field_if', parameter_values: [1]
      )
      expect(bit_fields[1]).to have_interface(
        :bit_field_sub_if,
        name: 'bit_field_sub_if', interface_type: 'rggen_bit_field_if', parameter_values: [8]
      )
      expect(bit_fields[2]).to have_interface(
        :bit_field_sub_if,
        name: 'bit_field_sub_if', interface_type: 'rggen_bit_field_if', parameter_values: [8]
      )
      expect(bit_fields[3]).to have_interface(
        :bit_field_sub_if,
        name: 'bit_field_sub_if', interface_type: 'rggen_bit_field_if', parameter_values: [64]
      )
    end
  end

  describe '#local_index/#local_indices' do
    let(:bit_fields) do
      create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_3'
          size [2]
          register do
            name 'register_0'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_4'
          size [2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
            end
          end
        end
      end
    end

    describe '#local_index' do
      context 'ビットフィールドが連番ではない場合' do
        it 'nilを返す' do
          expect(bit_fields[0].local_index).to be_nil
          expect(bit_fields[2].local_index).to be_nil
          expect(bit_fields[4].local_index).to be_nil
          expect(bit_fields[6].local_index).to be_nil
          expect(bit_fields[8].local_index).to be_nil
        end
      end

      context 'ビットフィールドが連番になっている場合' do
        it 'スコープ中のインデックスを返す' do
          expect(bit_fields[1].local_index).to match_identifier('i')
          expect(bit_fields[3].local_index).to match_identifier('j')
          expect(bit_fields[5].local_index).to match_identifier('k')
          expect(bit_fields[7].local_index).to match_identifier('k')
          expect(bit_fields[9].local_index).to match_identifier('k')
        end
      end
    end

    describe '#local_indices' do
      it '上位階層も含た#local_indexの一覧を返す' do
        expect(bit_fields[0].local_indices).to match([nil, nil])
        expect(bit_fields[1].local_indices).to match([nil, 'i'])
        expect(bit_fields[2].local_indices).to match(['i', nil])
        expect(bit_fields[3].local_indices).to match(['i', 'j'])
        expect(bit_fields[4].local_indices).to match(['2*i+j', nil])
        expect(bit_fields[5].local_indices).to match(['2*i+j', 'k'])
        expect(bit_fields[6].local_indices).to match(['i', 'j', nil])
        expect(bit_fields[7].local_indices).to match(['i', 'j', 'k'])
        expect(bit_fields[8].local_indices).to match(['i', nil, 'j', nil])
        expect(bit_fields[9].local_indices).to match(['i', nil, 'j', 'k'])
      end
    end
  end

  describe '#loop_variables' do
    context 'ビットフィールドがループ中にある場合' do
      it 'ループ変数の一覧を返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            size [4]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register do
            name 'register_2'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, sequence_size: 2; type :rw; initial_value 0 }
          end

          register do
            name 'register_3'
            size [4]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, sequence_size: 2; type :rw; initial_value 0 }
          end

          register do
            name 'register_4'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, sequence_size: 2; type :rw; initial_value 0 }
          end

          register_file do
            name 'register_file_5'
            size [2]
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
            end
          end

          register_file do
            name 'register_file_6'
            size [2]
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
            end
          end

          register_file do
            name 'register_file_7'
            size [2]
            register_file do
              name 'register_file_0'
              register do
                name 'register_0'
                size [2]
                bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
                bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 2; type :rw; initial_value 0 }
              end
            end
          end
        end

        expect(bit_fields[0].loop_variables).to match([
          match_identifier('i')
        ])
        expect(bit_fields[1].loop_variables).to match([
          match_identifier('i'), match_identifier('j')
        ])
        expect(bit_fields[2].loop_variables).to match([
          match_identifier('i')
        ])
        expect(bit_fields[3].loop_variables).to match([
          match_identifier('i'), match_identifier('j')
        ])
        expect(bit_fields[4].loop_variables).to match([
          match_identifier('i'), match_identifier('j'), match_identifier('k')
        ])
        expect(bit_fields[5].loop_variables).to match([
          match_identifier('i')
        ])
        expect(bit_fields[6].loop_variables).to match([
          match_identifier('i'), match_identifier('j')
        ])
        expect(bit_fields[7].loop_variables).to match([
          match_identifier('i'), match_identifier('j')
        ])
        expect(bit_fields[8].loop_variables).to match([
          match_identifier('i'), match_identifier('j'), match_identifier('k')
        ])
        expect(bit_fields[9].loop_variables).to match([
          match_identifier('i'), match_identifier('j')
        ])
        expect(bit_fields[10].loop_variables).to match([
          match_identifier('i'), match_identifier('j'), match_identifier('k')
        ])
      end
    end

    context 'ビットフィールドがループ中にないばあい' do
      it 'nilを返す' do
        bit_fields = create_bit_fields do
          name 'block_0'
          byte_size 256

          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end

          register_file do
            name 'register_file_1'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            end
          end
        end
        expect(bit_fields[0].loop_variables).to be_nil
        expect(bit_fields[1].loop_variables).to be_nil
      end
    end
  end

  describe '#value' do
    let(:bit_fields) do
      create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value 0 }
        end

        register do
          name 'register_2'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_3'
          size [2]
          register do
            name 'register_0'
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
            bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
            bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value 0 }
            bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_4'
          size [2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              size [2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
              bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
              bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
              bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value 0 }
              bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value 0 }
            end
          end
        end
      end
    end

    context '無引数の場合' do
      it '自身が保持する値への参照を返す' do
        expect(bit_fields[0].value).to match_identifier('register_if[0].value[0+:1]')
        expect(bit_fields[1].value).to match_identifier('register_if[0].value[8+:8]')
        expect(bit_fields[2].value).to match_identifier('register_if[0].value[16+1*i+:1]')
        expect(bit_fields[3].value).to match_identifier('register_if[0].value[20+2*i+:2]')
        expect(bit_fields[4].value).to match_identifier('register_if[0].value[24+4*i+:2]')

        expect(bit_fields[5].value).to match_identifier('register_if[1+i].value[0+:1]')
        expect(bit_fields[6].value).to match_identifier('register_if[1+i].value[8+:8]')
        expect(bit_fields[7].value).to match_identifier('register_if[1+i].value[16+1*j+:1]')
        expect(bit_fields[8].value).to match_identifier('register_if[1+i].value[20+2*j+:2]')
        expect(bit_fields[9].value).to match_identifier('register_if[1+i].value[24+4*j+:2]')

        expect(bit_fields[10].value).to match_identifier('register_if[5+2*i+j].value[0+:1]')
        expect(bit_fields[11].value).to match_identifier('register_if[5+2*i+j].value[8+:8]')
        expect(bit_fields[12].value).to match_identifier('register_if[5+2*i+j].value[16+1*k+:1]')
        expect(bit_fields[13].value).to match_identifier('register_if[5+2*i+j].value[20+2*k+:2]')
        expect(bit_fields[14].value).to match_identifier('register_if[5+2*i+j].value[24+4*k+:2]')

        expect(bit_fields[15].value).to match_identifier('register_if[9+2*(i)+j].value[0+:1]')
        expect(bit_fields[16].value).to match_identifier('register_if[9+2*(i)+j].value[8+:8]')
        expect(bit_fields[17].value).to match_identifier('register_if[9+2*(i)+j].value[16+1*k+:1]')
        expect(bit_fields[18].value).to match_identifier('register_if[9+2*(i)+j].value[20+2*k+:2]')
        expect(bit_fields[19].value).to match_identifier('register_if[9+2*(i)+j].value[24+4*k+:2]')

        expect(bit_fields[20].value).to match_identifier('register_if[13+2*(i)+j].value[0+:1]')
        expect(bit_fields[21].value).to match_identifier('register_if[13+2*(i)+j].value[8+:8]')
        expect(bit_fields[22].value).to match_identifier('register_if[13+2*(i)+j].value[16+1*k+:1]')
        expect(bit_fields[23].value).to match_identifier('register_if[13+2*(i)+j].value[20+2*k+:2]')
        expect(bit_fields[24].value).to match_identifier('register_if[13+2*(i)+j].value[24+4*k+:2]')
      end
    end

    context '引数でレジスタのオフセット/ビットフィールドのオフセット/幅が指定された場合' do
      it '指定されたオフセット/幅での自身が保持する値への参照を返す' do
        expect(bit_fields[0].value([1, 1], 1)).to match_identifier('register_if[0].value[0+:1]')
        expect(bit_fields[0].value(['i', 'j'], 1)).to match_identifier('register_if[0].value[0+:1]')

        expect(bit_fields[1].value([1, 1], 4)).to match_identifier('register_if[0].value[8+:4]')
        expect(bit_fields[1].value(['i', 'j'], 4)).to match_identifier('register_if[0].value[8+:4]')

        expect(bit_fields[2].value([1, 1], 1)).to match_identifier('register_if[0].value[17+:1]')
        expect(bit_fields[2].value(['i', 'j'], 1)).to match_identifier('register_if[0].value[16+1*j+:1]')

        expect(bit_fields[3].value([1, 1], 1)).to match_identifier('register_if[0].value[22+:1]')
        expect(bit_fields[3].value(['i', 'j'], 1)).to match_identifier('register_if[0].value[20+2*j+:1]')

        expect(bit_fields[4].value([1, 1], 1)).to match_identifier('register_if[0].value[28+:1]')
        expect(bit_fields[4].value(['i', 'j'], 1)).to match_identifier('register_if[0].value[24+4*j+:1]')

        expect(bit_fields[5].value([1, 1], 1)).to match_identifier('register_if[2].value[0+:1]')
        expect(bit_fields[5].value(['i', 'j'], 1)).to match_identifier('register_if[1+i].value[0+:1]')

        expect(bit_fields[6].value([1, 1], 4)).to match_identifier('register_if[2].value[8+:4]')
        expect(bit_fields[6].value(['i', 'j'], 4)).to match_identifier('register_if[1+i].value[8+:4]')

        expect(bit_fields[7].value([1, 1], 1)).to match_identifier('register_if[2].value[17+:1]')
        expect(bit_fields[7].value(['i', 'j'], 1)).to match_identifier('register_if[1+i].value[16+1*j+:1]')

        expect(bit_fields[8].value([1, 1], 1)).to match_identifier('register_if[2].value[22+:1]')
        expect(bit_fields[8].value(['i', 'j'], 1)).to match_identifier('register_if[1+i].value[20+2*j+:1]')

        expect(bit_fields[9].value([1, 1], 1)).to match_identifier('register_if[2].value[28+:1]')
        expect(bit_fields[9].value(['i', 'j'], 1)).to match_identifier('register_if[1+i].value[24+4*j+:1]')

        expect(bit_fields[15].value([1, 1, 1], 1)).to match_identifier('register_if[12].value[0+:1]')
        expect(bit_fields[15].value(['i', 'j', 'k'], 1)).to match_identifier('register_if[9+2*(i)+j].value[0+:1]')

        expect(bit_fields[16].value([1, 1, 1], 4)).to match_identifier('register_if[12].value[8+:4]')
        expect(bit_fields[16].value(['i', 'j', 'k'], 4)).to match_identifier('register_if[9+2*(i)+j].value[8+:4]')

        expect(bit_fields[17].value([1, 1, 1], 1)).to match_identifier('register_if[12].value[17+:1]')
        expect(bit_fields[17].value(['i', 'j', 'k'], 1)).to match_identifier('register_if[9+2*(i)+j].value[16+1*k+:1]')

        expect(bit_fields[18].value([1, 1, 1], 1)).to match_identifier('register_if[12].value[22+:1]')
        expect(bit_fields[18].value(['i', 'j', 'k'], 1)).to match_identifier('register_if[9+2*(i)+j].value[20+2*k+:1]')

        expect(bit_fields[19].value([1, 1, 1], 1)).to match_identifier('register_if[12].value[28+:1]')
        expect(bit_fields[19].value(['i', 'j', 'k'], 1)).to match_identifier('register_if[9+2*(i)+j].value[24+4*k+:1]')

        expect(bit_fields[20].value([1, 1, 1, 1], 1)).to match_identifier('register_if[16].value[0+:1]')
        expect(bit_fields[20].value(['i', 'j', 'k', 'l'], 1)).to match_identifier('register_if[13+2*(i)+k].value[0+:1]')

        expect(bit_fields[21].value([1, 1, 1, 1], 4)).to match_identifier('register_if[16].value[8+:4]')
        expect(bit_fields[21].value(['i', 'j', 'k', 'l'], 4)).to match_identifier('register_if[13+2*(i)+k].value[8+:4]')

        expect(bit_fields[22].value([1, 1, 1, 1], 1)).to match_identifier('register_if[16].value[17+:1]')
        expect(bit_fields[22].value(['i', 'j', 'k', 'l'], 1)).to match_identifier('register_if[13+2*(i)+k].value[16+1*l+:1]')

        expect(bit_fields[23].value([1, 1, 1, 1], 1)).to match_identifier('register_if[16].value[22+:1]')
        expect(bit_fields[23].value(['i', 'j', 'k', 'l'], 1)).to match_identifier('register_if[13+2*(i)+k].value[20+2*l+:1]')

        expect(bit_fields[24].value([1, 1, 1, 1], 1)).to match_identifier('register_if[16].value[28+:1]')
        expect(bit_fields[24].value(['i', 'j', 'k', 'l'], 1)).to match_identifier('register_if[13+2*(i)+k].value[24+4*l+:1]')
      end
    end
  end

  describe '#generate_code' do
    it 'ビットフィールド階層のコードを出力する' do
      bit_fields = create_bit_fields do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_1'
          offset_address 0x10
          size [4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_2'
          offset_address 0x20
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16, sequence_size: 2; type :rw; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 20, width: 2, sequence_size: 2; type :rw; initial_value default: 0 }
          bit_field { name 'bit_field_4'; bit_assignment lsb: 24, width: 2, sequence_size: 2, step: 4; type :rw; initial_value [0, 1] }
        end

        register do
          name 'register_3'
          offset_address 0x30
          bit_field { bit_assignment lsb: 0, width: 32; type :rw; initial_value 0 }
        end
      end

      expect(bit_fields[0]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          localparam bit INITIAL_VALUE = 1'h0;
          rggen_bit_field_if #(1) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_0_bit_field_0),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[1]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          localparam bit [7:0] INITIAL_VALUE = 8'h00;
          rggen_bit_field_if #(8) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 8)
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_0_bit_field_1),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[2]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar i;
          for (i = 0;i < 2;++i) begin : g
            localparam bit INITIAL_VALUE = 1'h0;
            rggen_bit_field_if #(1) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 16+1*i, 1)
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_0_bit_field_2[i]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[3]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar i;
          for (i = 0;i < 2;++i) begin : g
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 20+2*i, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (REGISTER_0_BIT_FIELD_3_INITIAL_VALUE[i]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_0_bit_field_3[i]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[4]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar i;
          for (i = 0;i < 2;++i) begin : g
            localparam bit [1:0] INITIAL_VALUE[2] = '{2'h0, 2'h1};
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 24+4*i, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE[i]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_0_bit_field_4[i]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[5]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          localparam bit INITIAL_VALUE = 1'h0;
          rggen_bit_field_if #(1) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_1_bit_field_0[i]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[6]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          localparam bit [7:0] INITIAL_VALUE = 8'h00;
          rggen_bit_field_if #(8) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 8)
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_1_bit_field_1[i]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[7]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar j;
          for (j = 0;j < 2;++j) begin : g
            localparam bit INITIAL_VALUE = 1'h0;
            rggen_bit_field_if #(1) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 16+1*j, 1)
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_1_bit_field_2[i][j]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[8]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar j;
          for (j = 0;j < 2;++j) begin : g
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 20+2*j, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (REGISTER_1_BIT_FIELD_3_INITIAL_VALUE[j]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_1_bit_field_3[i][j]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[9]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar j;
          for (j = 0;j < 2;++j) begin : g
            localparam bit [1:0] INITIAL_VALUE[2] = '{2'h0, 2'h1};
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 24+4*j, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE[j]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_1_bit_field_4[i][j]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[10]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_0
          localparam bit INITIAL_VALUE = 1'h0;
          rggen_bit_field_if #(1) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 1)
          rggen_bit_field #(
            .WIDTH          (1),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_2_bit_field_0[i][j]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[11]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_1
          localparam bit [7:0] INITIAL_VALUE = 8'h00;
          rggen_bit_field_if #(8) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 8, 8)
          rggen_bit_field #(
            .WIDTH          (8),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_2_bit_field_1[i][j]),
            .o_value_unmasked   ()
          );
        end
      CODE

      expect(bit_fields[12]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_2
          genvar k;
          for (k = 0;k < 2;++k) begin : g
            localparam bit INITIAL_VALUE = 1'h0;
            rggen_bit_field_if #(1) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 16+1*k, 1)
            rggen_bit_field #(
              .WIDTH          (1),
              .INITIAL_VALUE  (INITIAL_VALUE),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_2_bit_field_2[i][j][k]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[13]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_3
          genvar k;
          for (k = 0;k < 2;++k) begin : g
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 20+2*k, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (REGISTER_2_BIT_FIELD_3_INITIAL_VALUE[k]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_2_bit_field_3[i][j][k]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[14]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_bit_field_4
          genvar k;
          for (k = 0;k < 2;++k) begin : g
            localparam bit [1:0] INITIAL_VALUE[2] = '{2'h0, 2'h1};
            rggen_bit_field_if #(2) bit_field_sub_if();
            `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 24+4*k, 2)
            rggen_bit_field #(
              .WIDTH          (2),
              .INITIAL_VALUE  (INITIAL_VALUE[k]),
              .SW_READ_ACTION (RGGEN_READ_DEFAULT),
              .SW_WRITE_ONCE  (0)
            ) u_bit_field (
              .i_clk              (i_clk),
              .i_rst_n            (i_rst_n),
              .bit_field_if       (bit_field_sub_if),
              .i_sw_write_enable  ('1),
              .i_hw_write_enable  ('0),
              .i_hw_write_data    ('0),
              .i_hw_set           ('0),
              .i_hw_clear         ('0),
              .i_value            ('0),
              .i_mask             ('1),
              .o_value            (o_register_2_bit_field_4[i][j][k]),
              .o_value_unmasked   ()
            );
          end
        end
      CODE

      expect(bit_fields[15]).to generate_code(:register, :top_down, <<~'CODE')
        if (1) begin : g_register_3
          localparam bit [31:0] INITIAL_VALUE = 32'h00000000;
          rggen_bit_field_if #(32) bit_field_sub_if();
          `rggen_connect_bit_field_if(bit_field_if, bit_field_sub_if, 0, 32)
          rggen_bit_field #(
            .WIDTH          (32),
            .INITIAL_VALUE  (INITIAL_VALUE),
            .SW_READ_ACTION (RGGEN_READ_DEFAULT),
            .SW_WRITE_ONCE  (0)
          ) u_bit_field (
            .i_clk              (i_clk),
            .i_rst_n            (i_rst_n),
            .bit_field_if       (bit_field_sub_if),
            .i_sw_write_enable  ('1),
            .i_hw_write_enable  ('0),
            .i_hw_write_data    ('0),
            .i_hw_set           ('0),
            .i_hw_clear         ('0),
            .i_value            ('0),
            .i_mask             ('1),
            .o_value            (o_register_3),
            .o_value_unmasked   ()
          );
        end
      CODE
    end
  end
end
