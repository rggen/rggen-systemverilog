# frozen_string_literal: true

RSpec.describe 'bit_field/type' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :size, :offset_address])
    RgGen.enable(:register, [:name, :size, :offset_address, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:foo, :bar, :baz])
  end

  def create_bit_fields(&body)
    create_sv_ral { byte_size 256; instance_eval(&body) }.bit_fields
  end

  describe '#access' do
    before(:all) do
      RgGen.define_list_item_feature(:bit_field, :type, :foo) do
        register_map {}
        sv_ral {}
      end
      RgGen.define_list_item_feature(:bit_field, :type, :bar) do
        register_map {}
        sv_ral { access :baz }
      end
      RgGen.define_list_item_feature(:bit_field, :type, :baz) do
        register_map {}
        sv_ral { access { 'baz' * 2 } }
      end
    end

    after(:all) do
      delete_register_map_factory
      delete_sv_ral_factory
      RgGen.delete(:bit_field, :type, [:foo, :bar, :baz])
    end

    context 'アクセス権の指定がない場合' do
      it '大文字化した型名をアクセス権として返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo }
          end
        end
        expect(bit_fields[0].access).to eq 'FOO'
      end
    end

    context '.accessでアクセス権の指定がある場合' do
      it '指定されたアクセス権を大文字化して返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :bar }
          end
        end
        expect(bit_fields[0].access).to eq 'BAZ'
      end
    end

    context '.accessにブロックが渡された場合' do
      it 'ブロックの実行結果を大文字化してアクセス権として返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :baz }
          end
        end
        expect(bit_fields[0].access).to eq 'BAZBAZ'
      end
    end
  end

  describe '#model_name' do
    before(:all) do
      RgGen.define_list_item_feature(:bit_field, :type, :foo) do
        register_map {}
        sv_ral {}
      end
      RgGen.define_list_item_feature(:bit_field, :type, :bar) do
        register_map {}
        sv_ral { model_name :rggen_bar_field }
      end
      RgGen.define_list_item_feature(:bit_field, :type, :baz) do
        register_map {}
        sv_ral { model_name { "rggen_ral_#{bit_field.name}" } }
      end
    end

    after(:all) do
      delete_register_map_factory
      delete_sv_ral_factory
      RgGen.delete(:bit_field, :type, [:foo, :bar, :baz])
    end

    context 'モデル名の指定がない場合' do
      it 'rggen_ral_fieldをモデル名として返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo }
          end
        end
        expect(bit_fields[0].model_name).to eq 'rggen_ral_field'
      end
    end

    context '.model_nameでモデル名の指定がある場合' do
      it '指定されたモデル名を返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :bar }
          end
        end
        expect(bit_fields[0].model_name).to eq :rggen_bar_field
      end
    end

    context '.model_nameにブロックが渡された場合' do
      it 'ブロックの実行結果をモデル名として返す' do
        bit_fields = create_bit_fields do
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :baz }
          end
        end
        expect(bit_fields[0].model_name).to eq 'rggen_ral_bit_field_0'
      end
    end
  end

  describe '#ral_model' do
    before(:all) do
      RgGen.define_list_item_feature(:bit_field, :type, :foo) do
        register_map {}
        sv_ral {}
      end
      RgGen.define_list_item_feature(:bit_field, :type, :bar) do
        register_map {}
        sv_ral { model_name :rggen_bar_field }
      end
      RgGen.define_list_item_feature(:bit_field, :type, :baz) do
        register_map {}
        sv_ral { model_name { "rggen_ral_#{bit_field.name}" } }
      end
    end

    after(:all) do
      delete_register_map_factory
      delete_sv_ral_factory
      RgGen.delete(:bit_field, :type, [:foo, :bar, :baz])
    end

    it 'フィールドモデル変数#ral_model' do
      bit_fields = create_bit_fields do
        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 4; type :foo }
        end
        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :bar }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 4; type :bar }
        end
        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :baz }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 4; type :baz }
        end
      end

      expect(bit_fields[0]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_0', data_type: :rggen_ral_field, random: true
      )
      expect(bit_fields[1]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_1', data_type: :rggen_ral_field, random: true,
        array_size: [4], array_format: :unpacked
      )
      expect(bit_fields[2]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_0', data_type: :rggen_bar_field, random: true
      )
      expect(bit_fields[3]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_1', data_type: :rggen_bar_field, random: true,
        array_size: [4], array_format: :unpacked
      )
      expect(bit_fields[4]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_0', data_type: 'rggen_ral_bit_field_0', random: true
      )
      expect(bit_fields[5]).to have_variable(
        :register, :ral_model,
        name: 'bit_field_1', data_type: 'rggen_ral_bit_field_1', random: true,
        array_size: [4], array_format: :unpacked
      )
    end
  end

  describe '#constructors' do
    before(:all) do
      RgGen.define_list_item_feature(:bit_field, :type, :foo) do
        register_map { volatile; reference use: true }
        sv_ral {}
      end
      RgGen.define_list_item_feature(:bit_field, :type, :bar) do
        register_map { non_volatile }
        sv_ral {}
      end
      RgGen.define_list_item_feature(:bit_field, :type, :baz) do
        register_map {}
        sv_ral { access :rw }
      end
    end

    after(:all) do
      delete_register_map_factory
      delete_sv_ral_factory
      RgGen.delete(:bit_field, :type, [:foo, :bar])
    end

    it 'フィールドモデルの生成と構成を行うコードを出力する' do
      bit_fields = create_bit_fields do
        register do
          name 'register_0'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 8, width: 8; type :foo }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 16; type :foo; initial_value 0 }
          bit_field { name 'bit_field_3'; bit_assignment lsb: 24, width: 8; type :foo; initial_value 0xab }
        end

        register do
          name 'register_1'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :bar }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 1; type :baz }
        end

        register do
          name 'register_2'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 12; type :foo; initial_value 0 }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 12; type :foo; initial_value default: 1 }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8, width: 4, sequence_size: 4, step: 12; type :foo; initial_value [0, 1, 2, 3] }
        end

        register do
          name 'register_3'
          bit_field { bit_assignment lsb: 0; type :foo }
        end

        register_file do
          name 'register_file_3'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 4; type :foo }
          end
        end

        register do
          name 'register_4'
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo; reference 'register_0.bit_field_0' }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, sequence_size: 4; type :foo; reference 'register_2.bit_field_0' }
          bit_field { name 'bit_field_2'; bit_assignment lsb: 8; type :foo; reference 'register_3' }
        end

        register_file do
          name 'register_file_5'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :foo; reference 'register_file_3.register_0.bit_field_0' }
            bit_field { name 'bit_field_1'; bit_assignment lsb: 1, sequence_size: 4; type :foo; reference 'register_file_3.register_0.bit_field_1' }
          end
        end
      end

      code_block = RgGen::Core::Utility::CodeUtility::CodeBlock.new
      bit_fields.flat_map(&:constructors).each do |constructor|
        code_block << [constructor, "\n"]
      end

      expect(code_block).to match_string(<<~'CODE')
        `rggen_ral_create_field(bit_field_0, 0, 1, "FOO", 1, 1'h0, 0, -1, "")
        `rggen_ral_create_field(bit_field_1, 8, 8, "FOO", 1, 8'h00, 0, -1, "")
        `rggen_ral_create_field(bit_field_2, 16, 1, "FOO", 1, 1'h0, 1, -1, "")
        `rggen_ral_create_field(bit_field_3, 24, 8, "FOO", 1, 8'hab, 1, -1, "")
        `rggen_ral_create_field(bit_field_0, 0, 1, "BAR", 0, 1'h0, 0, -1, "")
        `rggen_ral_create_field(bit_field_1, 1, 1, "RW", 1, 1'h0, 0, -1, "")
        `rggen_ral_create_field(bit_field_0[0], 0, 4, "FOO", 1, 4'h0, 1, 0, "")
        `rggen_ral_create_field(bit_field_0[1], 12, 4, "FOO", 1, 4'h0, 1, 1, "")
        `rggen_ral_create_field(bit_field_0[2], 24, 4, "FOO", 1, 4'h0, 1, 2, "")
        `rggen_ral_create_field(bit_field_0[3], 36, 4, "FOO", 1, 4'h0, 1, 3, "")
        `rggen_ral_create_field(bit_field_1[0], 4, 4, "FOO", 1, 4'h1, 1, 0, "")
        `rggen_ral_create_field(bit_field_1[1], 16, 4, "FOO", 1, 4'h1, 1, 1, "")
        `rggen_ral_create_field(bit_field_1[2], 28, 4, "FOO", 1, 4'h1, 1, 2, "")
        `rggen_ral_create_field(bit_field_1[3], 40, 4, "FOO", 1, 4'h1, 1, 3, "")
        `rggen_ral_create_field(bit_field_2[0], 8, 4, "FOO", 1, 4'h0, 1, 0, "")
        `rggen_ral_create_field(bit_field_2[1], 20, 4, "FOO", 1, 4'h1, 1, 1, "")
        `rggen_ral_create_field(bit_field_2[2], 32, 4, "FOO", 1, 4'h2, 1, 2, "")
        `rggen_ral_create_field(bit_field_2[3], 44, 4, "FOO", 1, 4'h3, 1, 3, "")
        `rggen_ral_create_field(register_3, 0, 1, "FOO", 1, 1'h0, 0, -1, "")
        `rggen_ral_create_field(bit_field_0, 0, 1, "FOO", 1, 1'h0, 0, -1, "")
        `rggen_ral_create_field(bit_field_1[0], 1, 1, "FOO", 1, 1'h0, 0, 0, "")
        `rggen_ral_create_field(bit_field_1[1], 2, 1, "FOO", 1, 1'h0, 0, 1, "")
        `rggen_ral_create_field(bit_field_1[2], 3, 1, "FOO", 1, 1'h0, 0, 2, "")
        `rggen_ral_create_field(bit_field_1[3], 4, 1, "FOO", 1, 1'h0, 0, 3, "")
        `rggen_ral_create_field(bit_field_0, 0, 1, "FOO", 1, 1'h0, 0, -1, "register_0.bit_field_0")
        `rggen_ral_create_field(bit_field_1[0], 4, 1, "FOO", 1, 1'h0, 0, 0, "register_2.bit_field_0")
        `rggen_ral_create_field(bit_field_1[1], 5, 1, "FOO", 1, 1'h0, 0, 1, "register_2.bit_field_0")
        `rggen_ral_create_field(bit_field_1[2], 6, 1, "FOO", 1, 1'h0, 0, 2, "register_2.bit_field_0")
        `rggen_ral_create_field(bit_field_1[3], 7, 1, "FOO", 1, 1'h0, 0, 3, "register_2.bit_field_0")
        `rggen_ral_create_field(bit_field_2, 8, 1, "FOO", 1, 1'h0, 0, -1, "register_3.register_3")
        `rggen_ral_create_field(bit_field_0, 0, 1, "FOO", 1, 1'h0, 0, -1, "register_file_3.register_0.bit_field_0")
        `rggen_ral_create_field(bit_field_1[0], 1, 1, "FOO", 1, 1'h0, 0, 0, "register_file_3.register_0.bit_field_1")
        `rggen_ral_create_field(bit_field_1[1], 2, 1, "FOO", 1, 1'h0, 0, 1, "register_file_3.register_0.bit_field_1")
        `rggen_ral_create_field(bit_field_1[2], 3, 1, "FOO", 1, 1'h0, 0, 2, "register_file_3.register_0.bit_field_1")
        `rggen_ral_create_field(bit_field_1[3], 4, 1, "FOO", 1, 1'h0, 0, 3, "register_file_3.register_0.bit_field_1")
      CODE
    end
  end
end
