# frozen_string_literal: true

RSpec.describe 'register_file/sv_ral_model' do
  include_context 'sv ral common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rw])
    RgGen.enable(:register_file, :sv_ral_model)
  end

  let(:register_files) do
    sv_ral = create_sv_ral do
      byte_size 256

      register_file do
        name 'register_file_0'
        offset_address 0x00

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register do
          name 'register_1'
          offset_address 0x04
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end

      register_file do
        name 'register_file_1'
        offset_address 0x10

        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end

        register_file do
          name 'register_file_1'
          offset_address 0x04
          register do
            name 'register_0'
            offset_address 0x00
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_2'
        offset_address 0x20
        size [2, 2]

        register do
          name 'register_0'
          offset_address 0x00
          size [2, 2]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end

      register_file do
        name 'register_file_3'
        offset_address 0x60
        size [2, step: 32]

        register do
          name 'register_0'
          offset_address 0x00
          size [2, step: 8]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end

      register_file do
        name 'register_file_4'
        offset_address 0xa0
        size [2, 2]

        register_file do
          name 'register_file_0'
          offset_address 0x00

          register do
            name 'register_0'
            offset_address 0x00
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
        end
      end
    end
    sv_ral.register_files
  end

  it 'レジスタファイルモデル変数#ral_modelを持つ' do
    expect(register_files[0]).to have_variable(
      :register_block, :ral_model,
      name: 'register_file_0', data_type: 'register_file_0_reg_file_model', random: true
    )
    expect(register_files[1]).to have_variable(
      :register_block, :ral_model,
      name: 'register_file_1', data_type: 'register_file_1_reg_file_model', random: true
    )
    expect(register_files[2]).to have_variable(
      :register_file, :ral_model,
      name: 'register_file_1', data_type: 'register_file_1_register_file_1_reg_file_model', random: true
    )
    expect(register_files[3]).to have_variable(
      :register_block, :ral_model,
      name: 'register_file_2', data_type: 'register_file_2_reg_file_model', array_size: [2, 2], array_format: :unpacked, random: true
    )
    expect(register_files[4]).to have_variable(
      :register_block, :ral_model,
      name: 'register_file_3', data_type: 'register_file_3_reg_file_model', array_size: [2], array_format: :unpacked, random: true
    )
    expect(register_files[5]).to have_variable(
      :register_block, :ral_model,
      name: 'register_file_4', data_type: 'register_file_4_reg_file_model', array_size: [2, 2], array_format: :unpacked, random: true
    )
    expect(register_files[6]).to have_variable(
      :register_file, :ral_model,
      name: 'register_file_0', data_type: 'register_file_4_register_file_0_reg_file_model', random: true
    )
  end

  describe '#constructors' do
    it 'レジスタファイルモデルの生成と構成を行うコードを出力する' do
      code_block = RgGen::Core::Utility::CodeUtility::CodeBlock.new
      register_files.flat_map(&:constructors).each do |constructor|
        code_block << [constructor, "\n"]
      end

      expect(code_block).to match_string(<<~'CODE')
        `rggen_ral_create_reg_file(register_file_0, '{}, '{}, 8'h00, "g_register_file_0")
        `rggen_ral_create_reg_file(register_file_1, '{}, '{}, 8'h10, "g_register_file_1")
        `rggen_ral_create_reg_file(register_file_1, '{}, '{}, 8'h04, "g_register_file_1")
        `rggen_ral_create_reg_file(register_file_2[0][0], '{0, 0}, '{2, 2}, 8'h20, "g_register_file_2.g[0].g[0]")
        `rggen_ral_create_reg_file(register_file_2[0][1], '{0, 1}, '{2, 2}, 8'h30, "g_register_file_2.g[0].g[1]")
        `rggen_ral_create_reg_file(register_file_2[1][0], '{1, 0}, '{2, 2}, 8'h40, "g_register_file_2.g[1].g[0]")
        `rggen_ral_create_reg_file(register_file_2[1][1], '{1, 1}, '{2, 2}, 8'h50, "g_register_file_2.g[1].g[1]")
        `rggen_ral_create_reg_file(register_file_3[0], '{0}, '{2}, 8'h60, "g_register_file_3.g[0]")
        `rggen_ral_create_reg_file(register_file_3[1], '{1}, '{2}, 8'h80, "g_register_file_3.g[1]")
        `rggen_ral_create_reg_file(register_file_4[0][0], '{0, 0}, '{2, 2}, 8'ha0, "g_register_file_4.g[0].g[0]")
        `rggen_ral_create_reg_file(register_file_4[0][1], '{0, 1}, '{2, 2}, 8'hb0, "g_register_file_4.g[0].g[1]")
        `rggen_ral_create_reg_file(register_file_4[1][0], '{1, 0}, '{2, 2}, 8'hc0, "g_register_file_4.g[1].g[0]")
        `rggen_ral_create_reg_file(register_file_4[1][1], '{1, 1}, '{2, 2}, 8'hd0, "g_register_file_4.g[1].g[1]")
        `rggen_ral_create_reg_file(register_file_0, '{}, '{}, 8'h00, "g_register_file_0")
      CODE
    end
  end

  describe '#generate_code' do
    it 'レジスタファイルレベルのRALモデル定義を出力する' do
      expect(register_files[0]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_0_reg_file_model extends rggen_ral_reg_file;
          rand register_file_0_register_0_reg_model register_0;
          rand register_file_0_register_1_reg_model register_1;
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0, '{}, '{}, 8'h00, "RW", "g_register_0.u_register")
            `rggen_ral_create_reg(register_1, '{}, '{}, 8'h04, "RW", "g_register_1.u_register")
          endfunction
        endclass
      CODE

      expect(register_files[1]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_1_reg_file_model extends rggen_ral_reg_file;
          rand register_file_1_register_0_reg_model register_0;
          rand register_file_1_register_file_1_reg_file_model register_file_1;
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0, '{}, '{}, 8'h00, "RW", "g_register_0.u_register")
            `rggen_ral_create_reg_file(register_file_1, '{}, '{}, 8'h04, "g_register_file_1")
          endfunction
        endclass
      CODE

      expect(register_files[2]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_1_register_file_1_reg_file_model extends rggen_ral_reg_file;
          rand register_file_1_register_file_1_register_0_reg_model register_0;
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0, '{}, '{}, 8'h00, "RW", "g_register_0.u_register")
          endfunction
        endclass
      CODE

      expect(register_files[3]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_2_reg_file_model extends rggen_ral_reg_file;
          rand register_file_2_register_0_reg_model register_0[2][2];
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0[0][0], '{0, 0}, '{2, 2}, 8'h00, "RW", "g_register_0.g[0].g[0].u_register")
            `rggen_ral_create_reg(register_0[0][1], '{0, 1}, '{2, 2}, 8'h04, "RW", "g_register_0.g[0].g[1].u_register")
            `rggen_ral_create_reg(register_0[1][0], '{1, 0}, '{2, 2}, 8'h08, "RW", "g_register_0.g[1].g[0].u_register")
            `rggen_ral_create_reg(register_0[1][1], '{1, 1}, '{2, 2}, 8'h0c, "RW", "g_register_0.g[1].g[1].u_register")
          endfunction
        endclass
      CODE

      expect(register_files[4]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_3_reg_file_model extends rggen_ral_reg_file;
          rand register_file_3_register_0_reg_model register_0[2];
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0[0], '{0}, '{2}, 8'h00, "RW", "g_register_0.g[0].u_register")
            `rggen_ral_create_reg(register_0[1], '{1}, '{2}, 8'h08, "RW", "g_register_0.g[1].u_register")
          endfunction
        endclass
      CODE

      expect(register_files[5]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_4_reg_file_model extends rggen_ral_reg_file;
          rand register_file_4_register_file_0_reg_file_model register_file_0;
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg_file(register_file_0, '{}, '{}, 8'h00, "g_register_file_0")
          endfunction
        endclass
      CODE

      expect(register_files[6]).to generate_code(:ral_package, :bottom_up, 0, <<~'CODE')
        class register_file_4_register_file_0_reg_file_model extends rggen_ral_reg_file;
          rand register_file_4_register_file_0_register_0_reg_model register_0[2][2];
          function new(string name);
            super.new(name, 4, 0);
          endfunction
          function void build();
            `rggen_ral_create_reg(register_0[0][0], '{0, 0}, '{2, 2}, 8'h00, "RW", "g_register_0.g[0].g[0].u_register")
            `rggen_ral_create_reg(register_0[0][1], '{0, 1}, '{2, 2}, 8'h04, "RW", "g_register_0.g[0].g[1].u_register")
            `rggen_ral_create_reg(register_0[1][0], '{1, 0}, '{2, 2}, 8'h08, "RW", "g_register_0.g[1].g[0].u_register")
            `rggen_ral_create_reg(register_0[1][1], '{1, 1}, '{2, 2}, 8'h0c, "RW", "g_register_0.g[1].g[1].u_register")
          endfunction
        endclass
      CODE
    end
  end
end
