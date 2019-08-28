# frozen_string_literal: true

RSpec.describe 'bit_field/type' do
  include_context 'clean-up builder'
  include_context 'sv ral common'

  before(:all) do
    RgGen.enable(:register, [:name, :size, :type])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :initial_value, :reference, :type])
    RgGen.enable(:bit_field, :type, [:foo, :bar, :baz])
  end

  def create_bit_fields(&body)
    create_sv_ral(&body).bit_fields
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
    end

    after(:all) do
      delete_register_map_factory
      delete_sv_ral_factory
      RgGen.delete(:bit_field, :type, [:foo, :bar])
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
        expect(bit_fields[0].model_name).to eq :rggen_ral_field
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
        register_map { volatile }
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
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0, width: 4, sequence_size: 4, step: 8; type :foo }
          bit_field { name 'bit_field_1'; bit_assignment lsb: 4, width: 4, sequence_size: 4, step: 8; type :foo }
        end

        register do
          name 'register_3'
          bit_field { bit_assignment lsb: 0; type :foo }
        end
      end

      code_block = RgGen::Core::Utility::CodeUtility::CodeBlock.new
      bit_fields.flat_map(&:constructors).each do |constructor|
        code_block << [constructor, "\n"]
      end

      expect(code_block).to match_string(<<~'CODE')
        `rggen_ral_create_field_model(bit_field_0, 0, 1, FOO, 1, 1'h0, 0)
        `rggen_ral_create_field_model(bit_field_1, 8, 8, FOO, 1, 8'h00, 0)
        `rggen_ral_create_field_model(bit_field_2, 16, 1, FOO, 1, 1'h0, 1)
        `rggen_ral_create_field_model(bit_field_3, 24, 8, FOO, 1, 8'hab, 1)
        `rggen_ral_create_field_model(bit_field_0, 0, 1, BAR, 0, 1'h0, 0)
        `rggen_ral_create_field_model(bit_field_1, 1, 1, RW, 1, 1'h0, 0)
        `rggen_ral_create_field_model(bit_field_0[0], 0, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_0[1], 8, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_0[2], 16, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_0[3], 24, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_1[0], 4, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_1[1], 12, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_1[2], 20, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(bit_field_1[3], 28, 4, FOO, 1, 4'h0, 0)
        `rggen_ral_create_field_model(register_3, 0, 1, FOO, 1, 1'h0, 0)
      CODE
    end
  end
end
