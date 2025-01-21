# frozen_string_literal: true

RSpec.describe 'bit_field/sv_rtl_package' do
  include_context 'sv rtl package common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :__offset_address, :size])
    RgGen.enable(:register, [:name, :__offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference, :labels])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:bit_field, :sv_rtl_package)
  end

  describe 'パラメータ宣言' do
    let(:sv_rtl_package) do
      sv_rtl_package = create_sv_rtl_package do
        name 'block_0'
        byte_size 256

        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 16, width:  4; type :rw; initial_value 0 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 24, width: 16; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          bit_field {
            bit_assignment lsb: 0, width: 64
            type :rw
            initial_value 0
            labels [
              { name: 'FOO', value: 0         },
              { name: 'BAR', value: 2**16 - 1 },
              { name: 'BAZ', value: 2**32 - 1 },
              { name: 'QUX', value: 2**48 - 1 },
            ]
          }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :rw; initial_value 0 }
        end

        register do
          name 'register_3'
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_4'
          register do
            name 'register_4_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          end
          register do
            name 'register_4_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
          end
          register_file do
            name 'register_file_4_2'
            size [2, 2]
            register do
              name 'register_4_2_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb:  0, width:  1; type :rw; initial_value 0 }
            end
            register do
              name 'register_4_2_1'
              size [2, 2]
              bit_field {
                name 'bit_field_0'
                bit_assignment lsb:  0, width:  1
                type :rw; initial_value 0
                labels [
                  { name: 'FIZZ', value: 0 },
                  { name: 'BUZZ', value: 1 }
                ]
              }
            end
          end
        end
      end
      sv_rtl_package.bit_fields
    end

    specify 'ビット幅/ビットマスク/ビット位置を示すパラメータが宣言される' do
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_0_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_0_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_0_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_0_BIT_FIELD_1_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_0_BIT_FIELD_1_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 4, default: "4'hf"
      )
      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_0_BIT_FIELD_1_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 16
      )

      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_0_BIT_FIELD_2_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_0_BIT_FIELD_2_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 16, default: "16'hffff"
      )
      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_0_BIT_FIELD_2_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 24
      )

      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_1_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 64
      )
      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_1_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 64, default: "64'hffffffffffffffff"
      )
      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_1_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_2_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_2_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 4, default: "4'hf"
      )
      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_2_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, array_size: [4], array_format: :unpacked, default: "'{0, 8, 16, 24}"
      )

      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_2_BIT_FIELD_1_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_2_BIT_FIELD_1_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 4, default: "4'hf"
      )
      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_2_BIT_FIELD_1_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, array_size: [4], array_format: :unpacked,  default: "'{4, 12, 20, 28}"
      )

      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_3_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_3_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_3_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_4_REGISTER_4_0_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_4_REGISTER_4_1_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_0_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )

      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__width,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 1
      )
      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__mask,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_MASK', parameter_type: :localparam,
        data_type: :bit, width: 1, default: "1'h1"
      )
      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BIT_OFFSET', parameter_type: :localparam,
        data_type: :int, default: 0
      )
    end

    context 'ラベルの指定がある場合' do
      specify 'ラベルを示すパラメータが定義される' do
        expect(sv_rtl_package[3]).to have_parameter(
          :register_block, :label_foo,
          name: 'REGISTER_1_FOO', parameter_type: :localparam,
          data_type: :bit, width: 64, default: "64'h0000000000000000"
        )
        expect(sv_rtl_package[3]).to have_parameter(
          :register_block, :label_bar,
          name: 'REGISTER_1_BAR', parameter_type: :localparam,
          data_type: :bit, width: 64, default: "64'h000000000000ffff"
        )
        expect(sv_rtl_package[3]).to have_parameter(
          :register_block, :label_baz,
          name: 'REGISTER_1_BAZ', parameter_type: :localparam,
          data_type: :bit, width: 64, default: "64'h00000000ffffffff"
        )
        expect(sv_rtl_package[3]).to have_parameter(
          :register_block, :label_qux,
          name: 'REGISTER_1_QUX', parameter_type: :localparam,
          data_type: :bit, width: 64, default: "64'h0000ffffffffffff"
        )

        expect(sv_rtl_package[10]).to have_parameter(
          :register_block, :label_fizz,
          name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_FIZZ',
          parameter_type: :localparam, data_type: :bit, width: 1, default: "1'h0"
        )
        expect(sv_rtl_package[10]).to have_parameter(
          :register_block, :label_buzz,
          name: 'REGISTER_FILE_4_REGISTER_FILE_4_2_REGISTER_4_2_1_BIT_FIELD_0_BUZZ',
          parameter_type: :localparam, data_type: :bit, width: 1, default: "1'h1"
        )
      end
    end
  end
end
