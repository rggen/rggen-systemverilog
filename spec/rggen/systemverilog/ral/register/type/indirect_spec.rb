# frozen_string_literal: true

RSpec.describe 'register/type/indirect' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format])
    RgGen.enable(:register_block, [:byte_size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:ro, :rw, :wo, :reserved])
  end

  let(:registers) do
    sv_ral = create_sv_ral do
      byte_size 256

      register do
        name 'register_0'
        offset_address 0x00
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
        bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 2; type :rw; initial_value 0 }
        bit_field { name 'bit_field_2'; bit_assignment lsb: 16, width: 4; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        offset_address 0x04
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_2'
        offset_address 0x08
        bit_field { bit_assignment lsb: 0, width: 2; type :rw; initial_value 0 }
      end

      register do
        name 'register_3'
        offset_address 0x10
        type [:indirect, ['register_0.bit_field_0', 1]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_4'
        offset_address 0x14
        size [2]
        type [:indirect, 'register_0.bit_field_1']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_5'
        offset_address 0x18
        size [2, 4]
        type [:indirect, 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_6'
        offset_address 0x1c
        size [2, 4]
        type [:indirect, ['register_0.bit_field_0', 0], 'register_0.bit_field_1', 'register_0.bit_field_2']
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_7'
        offset_address 0x20
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :ro }
      end

      register do
        name 'register_8'
        offset_address 0x24
        type [:indirect, ['register_0.bit_field_0', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :wo; initial_value 0 }
      end

      register do
        name 'register_9'
        offset_address 0x28
        size [2]
        type [:indirect, 'register_1', ['register_2', 0]]
        bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 1; type :rw; initial_value 0 }
      end
    end
    sv_ral.registers
  end

  it 'レジスタモデル変数#ral_modelを持つ' do
    expect(registers[3]).to have_variable(
      :register_block, :ral_model,
      name: 'register_3', data_type: 'register_3_reg_model', random: true
    )
    expect(registers[4]).to have_variable(
      :register_block, :ral_model,
      name: 'register_4', data_type: 'register_4_reg_model',
      array_size: [2], array_format: :unpacked, random: true
    )
    expect(registers[5]).to have_variable(
      :register_block, :ral_model,
      name: 'register_5', data_type: 'register_5_reg_model',
      array_size: [2, 4], array_format: :unpacked, random: true
    )
    expect(registers[6]).to have_variable(
      :register_block, :ral_model,
      name: 'register_6', data_type: 'register_6_reg_model',
      array_size: [2, 4], array_format: :unpacked, random: true
    )
    expect(registers[7]).to have_variable(
      :register_block, :ral_model,
      name: 'register_7', data_type: 'register_7_reg_model', random: true
    )
    expect(registers[8]).to have_variable(
      :register_block, :ral_model,
      name: 'register_8', data_type: 'register_8_reg_model', random: true
    )
    expect(registers[9]).to have_variable(
      :register_block, :ral_model,
      name: 'register_9', data_type: 'register_9_reg_model',
      array_size: [2], array_format: :unpacked, random: true
    )
  end

  describe '#constructors' do
    it 'レジスタモデルの生成と構成を行うコードを出力する' do
      code_block = RgGen::Core::Utility::CodeUtility::CodeBlock.new
      registers[3..-1].flat_map(&:constructors).each do |constructor|
        code_block << [constructor, "\n"]
      end

      expect(code_block).to match_string(<<~'CODE')
        `rggen_ral_create_reg_model(register_3, '{}, 8'h10, RW, 1, g_register_3.u_register)
        `rggen_ral_create_reg_model(register_4[0], '{0}, 8'h14, RW, 1, g_register_4.g[0].u_register)
        `rggen_ral_create_reg_model(register_4[1], '{1}, 8'h14, RW, 1, g_register_4.g[1].u_register)
        `rggen_ral_create_reg_model(register_5[0][0], '{0, 0}, 8'h18, RW, 1, g_register_5.g[0].g[0].u_register)
        `rggen_ral_create_reg_model(register_5[0][1], '{0, 1}, 8'h18, RW, 1, g_register_5.g[0].g[1].u_register)
        `rggen_ral_create_reg_model(register_5[0][2], '{0, 2}, 8'h18, RW, 1, g_register_5.g[0].g[2].u_register)
        `rggen_ral_create_reg_model(register_5[0][3], '{0, 3}, 8'h18, RW, 1, g_register_5.g[0].g[3].u_register)
        `rggen_ral_create_reg_model(register_5[1][0], '{1, 0}, 8'h18, RW, 1, g_register_5.g[1].g[0].u_register)
        `rggen_ral_create_reg_model(register_5[1][1], '{1, 1}, 8'h18, RW, 1, g_register_5.g[1].g[1].u_register)
        `rggen_ral_create_reg_model(register_5[1][2], '{1, 2}, 8'h18, RW, 1, g_register_5.g[1].g[2].u_register)
        `rggen_ral_create_reg_model(register_5[1][3], '{1, 3}, 8'h18, RW, 1, g_register_5.g[1].g[3].u_register)
        `rggen_ral_create_reg_model(register_6[0][0], '{0, 0}, 8'h1c, RW, 1, g_register_6.g[0].g[0].u_register)
        `rggen_ral_create_reg_model(register_6[0][1], '{0, 1}, 8'h1c, RW, 1, g_register_6.g[0].g[1].u_register)
        `rggen_ral_create_reg_model(register_6[0][2], '{0, 2}, 8'h1c, RW, 1, g_register_6.g[0].g[2].u_register)
        `rggen_ral_create_reg_model(register_6[0][3], '{0, 3}, 8'h1c, RW, 1, g_register_6.g[0].g[3].u_register)
        `rggen_ral_create_reg_model(register_6[1][0], '{1, 0}, 8'h1c, RW, 1, g_register_6.g[1].g[0].u_register)
        `rggen_ral_create_reg_model(register_6[1][1], '{1, 1}, 8'h1c, RW, 1, g_register_6.g[1].g[1].u_register)
        `rggen_ral_create_reg_model(register_6[1][2], '{1, 2}, 8'h1c, RW, 1, g_register_6.g[1].g[2].u_register)
        `rggen_ral_create_reg_model(register_6[1][3], '{1, 3}, 8'h1c, RW, 1, g_register_6.g[1].g[3].u_register)
        `rggen_ral_create_reg_model(register_7, '{}, 8'h20, RO, 1, g_register_7.u_register)
        `rggen_ral_create_reg_model(register_8, '{}, 8'h24, WO, 1, g_register_8.u_register)
        `rggen_ral_create_reg_model(register_9[0], '{0}, 8'h28, RW, 1, g_register_9.g[0].u_register)
        `rggen_ral_create_reg_model(register_9[1], '{1}, 8'h28, RW, 1, g_register_9.g[1].u_register)
      CODE
    end
  end

  describe '#generate_code' do
    it 'レジスタレベルのRALモデルの定義を出力する' do
      expect(registers[3]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_3_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RW, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_0", 1'h1);
          endfunction
        endclass
      CODE

      expect(registers[4]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_4_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RW, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_1", array_index[0]);
          endfunction
        endclass
      CODE

      expect(registers[5]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_5_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RW, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_1", array_index[0]);
            setup_index_field("register_0", "bit_field_2", array_index[1]);
          endfunction
        endclass
      CODE

      expect(registers[6]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_6_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RW, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_0", 1'h0);
            setup_index_field("register_0", "bit_field_1", array_index[0]);
            setup_index_field("register_0", "bit_field_2", array_index[1]);
          endfunction
        endclass
      CODE

      expect(registers[7]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_7_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RO, 1, 1'h0, 0)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_0", 1'h0);
          endfunction
        endclass
      CODE

      expect(registers[8]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_8_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, WO, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_0", "bit_field_0", 1'h0);
          endfunction
        endclass
      CODE

      expect(registers[9]).to generate_code(:ral_package, :bottom_up, <<~'CODE')
        class register_9_reg_model extends rggen_ral_indirect_reg;
          rand rggen_ral_field bit_field_0;
          function new(string name);
            super.new(name, 32, 0);
          endfunction
          function void build();
            `rggen_ral_create_field_model(bit_field_0, 0, 1, RW, 0, 1'h0, 1)
          endfunction
          function void setup_index_fields();
            setup_index_field("register_1", "register_1", array_index[0]);
            setup_index_field("register_2", "register_2", 2'h0);
          endfunction
        endclass
      CODE
    end
  end
end
