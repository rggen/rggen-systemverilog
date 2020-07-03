# frozen_string_literal: true

RSpec.describe 'register_block/sv_ral_model' do
  include_context 'sv ral common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:register_block, :sv_ral_model)
    RgGen.enable(:register_file, :sv_ral_model)
  end

  let(:register_block) do
    sv_ral = create_sv_ral do
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
        size [2, 2]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_2'
        offset_address 0x20
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end

      register_file do
        name 'register_file_3'
        offset_address 0x30
        size [2, 2]
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end

      register do
        name 'register_4'
        offset_address 0x40
        size [4]
        type [:external]
      end
    end
    sv_ral.register_blocks[0]
  end

  describe '#generate_code' do
    it 'レジスタブロックレベルのRALモデルの定義を出力する' do
      expect(register_block).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class block_0_block_model #(
          type REGISTER_4 = rggen_ral_block,
          bit INTEGRATE_REGISTER_4 = 1
        ) extends rggen_ral_block;
          rand register_0_reg_model register_0;
          rand register_1_reg_model register_1[2][2];
          rand register_file_2_reg_file_model register_file_2;
          rand register_file_3_reg_file_model register_file_3[2][2];
          rand REGISTER_4 register_4;
          function new(string name);
            super.new(name, 4);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0, '{}, 8'h00, "RW", "g_register_0.u_register")
            `rggen_ral_create_reg(register_1[0][0], '{0, 0}, 8'h10, "RW", "g_register_1.g[0].g[0].u_register")
            `rggen_ral_create_reg(register_1[0][1], '{0, 1}, 8'h14, "RW", "g_register_1.g[0].g[1].u_register")
            `rggen_ral_create_reg(register_1[1][0], '{1, 0}, 8'h18, "RW", "g_register_1.g[1].g[0].u_register")
            `rggen_ral_create_reg(register_1[1][1], '{1, 1}, 8'h1c, "RW", "g_register_1.g[1].g[1].u_register")
            `rggen_ral_create_reg_file(register_file_2, '{}, 8'h20, "g_register_file_2")
            `rggen_ral_create_reg_file(register_file_3[0][0], '{0, 0}, 8'h30, "g_register_file_3.g[0].g[0]")
            `rggen_ral_create_reg_file(register_file_3[0][1], '{0, 1}, 8'h34, "g_register_file_3.g[0].g[1]")
            `rggen_ral_create_reg_file(register_file_3[1][0], '{1, 0}, 8'h38, "g_register_file_3.g[1].g[0]")
            `rggen_ral_create_reg_file(register_file_3[1][1], '{1, 1}, 8'h3c, "g_register_file_3.g[1].g[1]")
            `rggen_ral_create_block(register_4, 8'h40, this, INTEGRATE_REGISTER_4)
          endfunction
        endclass
      CODE
    end
  end
end
