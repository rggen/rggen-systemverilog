# frozen_string_literal: true

RSpec.describe 'register/sv_rtl_package' do
  include_context 'sv rtl package common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference, :labels])
    RgGen.enable(:bit_field, :type, [:rw, :wo, :ro])
    RgGen.enable(:register, :sv_rtl_package)
  end

  let(:sv_rtl_package) do
    sv_rtl_package = create_sv_rtl_package do
      name 'block_0'
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { name 'bit_field_0'; bit_assignment lsb: 32, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_3'
        offset_address 0x0c
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_4'
        offset_address 0x10
        size [4]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x20
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x30
        size [4]
        type [:indirect, 'register_0.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x34
        size [2, 2]
        type [:indirect, 'register_0.bit_field_0', 'register_1.bit_field_0']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_8'
        offset_address 0x40
        size [4]
        type :external
      end

      register_file do
        name 'register_file_9'
        offset_address 0x50

        register do
          name 'register_9_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_9_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_9_2'
          offset_address 0x10

          register do
            name 'register_9_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_9_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_10'
        offset_address 0x70
        size [2, 2]

        register do
          name 'register_10_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register do
          name 'register_10_1'
          offset_address 0x08
          size [2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_10_2'
          offset_address 0x10

          register do
            name 'register_10_2_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end

          register do
            name 'register_10_2_1'
            offset_address 0x08
            size [2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
          end
        end
      end
    end
    sv_rtl_package.registers
  end

  describe 'パラメータ定義' do
    it 'バイト幅/バイト長/配列長/オフセットアドレスを示すパラメータを定義する' do
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_0_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_0_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[0]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_0_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h00"
      )

      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_1_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 8
      )
      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_1_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 8
      )
      expect(sv_rtl_package[1]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_1_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h04"
      )

      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_2_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_2_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[2]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_2_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h0c"
      )

      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_3_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_3_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[3]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_3_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h0c"
      )

      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_4_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_4_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_4_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [1], array_format: :unpacked, default: "'{4}"
      )
      expect(sv_rtl_package[4]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_4_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [4], array_format: :unpacked, default: "'{8'h10, 8'h14, 8'h18, 8'h1c}"
      )

      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_5_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_5_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_5_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [2], array_format: :unpacked, default: "'{2, 2}"
      )
      expect(sv_rtl_package[5]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_5_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2], array_format: :unpacked, default: "'{'{8'h20, 8'h24}, '{8'h28, 8'h2c}}"
      )

      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_6_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_6_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_6_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [1], array_format: :unpacked, default: "'{4}"
      )
      expect(sv_rtl_package[6]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_6_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [4], array_format: :unpacked, default: "'{8'h30, 8'h30, 8'h30, 8'h30}"
      )

      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_7_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_7_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_7_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [2], array_format: :unpacked, default: "'{2, 2}"
      )
      expect(sv_rtl_package[7]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_7_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2], array_format: :unpacked, default: "'{'{8'h34, 8'h34}, '{8'h34, 8'h34}}"
      )

      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_8_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_8_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[8]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_8_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h40"
      )

      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_9_REGISTER_9_0_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_9_REGISTER_9_0_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[9]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_9_REGISTER_9_0_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h50"
      )

      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_9_REGISTER_9_1_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_9_REGISTER_9_1_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 8
      )
      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_9_REGISTER_9_1_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [1], array_format: :unpacked, default: "'{2}"
      )
      expect(sv_rtl_package[10]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_9_REGISTER_9_1_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h58, 8'h5c}"
      )

      expect(sv_rtl_package[11]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[11]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[11]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_0_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, default: "8'h60"
      )

      expect(sv_rtl_package[12]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[12]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 8
      )
      expect(sv_rtl_package[12]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [1], array_format: :unpacked, default: "'{2}"
      )
      expect(sv_rtl_package[12]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_9_REGISTER_FILE_9_2_REGISTER_9_2_1_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2], array_format: :unpacked, default: "'{8'h68, 8'h6c}"
      )

      expect(sv_rtl_package[13]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_10_REGISTER_10_0_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[13]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_10_REGISTER_10_0_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[13]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_10_REGISTER_10_0_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [2], array_format: :unpacked, default: "'{2, 2}"
      )
      expect(sv_rtl_package[13]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_10_REGISTER_10_0_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2], array_format: :unpacked, default: "'{'{8'h70, 8'h90}, '{8'hb0, 8'hd0}}"
      )

      expect(sv_rtl_package[14]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_10_REGISTER_10_1_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[14]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_10_REGISTER_10_1_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 32
      )
      expect(sv_rtl_package[14]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_10_REGISTER_10_1_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [3], array_format: :unpacked, default: "'{2, 2, 2}"
      )
      expect(sv_rtl_package[14]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_10_REGISTER_10_1_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2, 2], array_format: :unpacked, default: "'{'{'{8'h78, 8'h7c}, '{8'h98, 8'h9c}}, '{'{8'hb8, 8'hbc}, '{8'hd8, 8'hdc}}}"
      )

      expect(sv_rtl_package[15]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[15]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 16
      )
      expect(sv_rtl_package[15]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [2], array_format: :unpacked, default: "'{2, 2}"
      )
      expect(sv_rtl_package[15]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_0_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2], array_format: :unpacked, default: "'{'{8'h80, 8'ha0}, '{8'hc0, 8'he0}}"
      )

      expect(sv_rtl_package[16]).to have_parameter(
        :register_block, :__byte_width,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_WIDTH', parameter_type: :localparam,
        data_type: :int, default: 4
      )
      expect(sv_rtl_package[16]).to have_parameter(
        :register_block, :__byte_size,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_SIZE', parameter_type: :localparam,
        data_type: :int, default: 32
      )
      expect(sv_rtl_package[16]).to have_parameter(
        :register_block, :__array_size,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_ARRAY_SIZE', parameter_type: :localparam,
        data_type: :int, array_size: [3], array_format: :unpacked, default: "'{2, 2, 2}"
      )
      expect(sv_rtl_package[16]).to have_parameter(
        :register_block, :__offset,
        name: 'REGISTER_FILE_10_REGISTER_FILE_10_2_REGISTER_10_2_1_BYTE_OFFSET', parameter_type: :localparam,
        data_type: :bit, width: 8, array_size: [2, 2, 2], array_format: :unpacked, default: "'{'{'{8'h88, 8'h8c}, '{8'ha8, 8'hac}}, '{'{8'hc8, 8'hcc}, '{8'he8, 8'hec}}}"
      )
    end
  end
end
