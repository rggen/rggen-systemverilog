# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RTL::RegisterIndex do
  include_context 'clean-up builder'
  include_context 'sv rtl common'

  before(:all) do
    RgGen.define_simple_feature(:register_file, :index) do
      sv_rtl do
        include RgGen::SystemVerilog::RTL::RegisterIndex
      end
    end

    RgGen.define_simple_feature(:register, :index) do
      sv_rtl do
        include RgGen::SystemVerilog::RTL::RegisterIndex
      end
    end
  end

  before(:all) do
    RgGen.enable(:global, [:address_width, :enable_wide_register])
    RgGen.enable(:register_block, [:byte_size, :bus_width])
    RgGen.enable(:register_file, [:name, :offset_address, :size, :index])
    RgGen.enable(:register, [:name, :offset_address, :size, :type, :index])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference, :sv_rtl_top])
    RgGen.enable(:bit_field, :type, [:rw])
  end

  after(:all) do
    RgGen.delete(:register_file, :index)
    RgGen.delete(:register, :index)
  end

  let(:register_block) do
    root = create_sv_rtl do
      byte_size 512

      register do
        name 'register_0'
        bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
      end

      register do
        name 'register_1'
        size [2, 3]
        bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
      end

      register_file do
        name 'register_file_2'
        register do
          name 'register_2_0'
          bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
        end
        register do
          name 'register_2_1'
          bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
        end
        register_file do
          name 'register_file_2_2'
          register do
            name 'register_2_2_0'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
          register do
            name 'register_2_2_1'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_3'
        size [2]
        register do
          name 'register_3_0'
          size [2, 2]
          bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
        end
        register_file do
          name 'register_file_3_1'
          size [2, 2]
          register do
            size [2, 2]
            name 'register_3_1_0'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
          register do
            name 'register_3_1_1'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_4'
        size [2, 2]
        register_file do
          name 'regsiter_file_4_0'
          register do
            name 'register_4_0_0'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register_file do
        name 'register_file_5'
        size [2, 2]
        register_file do
          name 'register_file_5_0'
          register do
            size [2, 2]
            name 'register_5_0_0'
            bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
          end
        end
      end

      register do
        name 'register_6'
        bit_field { bit_assignment width: 1; type :rw; initial_value 0 }
      end
    end
    root.register_blocks[0]
  end

  let(:components) do
    collect_register_file_and_register(register_block)
  end

  def collect_register_file_and_register(component)
    [
      *((component.register_file? || component.register?) ? component : nil),
      *component.children.flat_map { |child| collect_register_file_and_register(child) }
    ]
  end

  describe '#index' do
    context '無引数の場合' do
      it 'レジスタブロック内でのインデックスを返す' do
        expect(components[0].index).to eq 0
        expect(components[1].index).to eq '1+3*i+j'
        expect(components[2].index).to eq 7
        expect(components[3].index).to eq 7
        expect(components[4].index).to eq 8
        expect(components[5].index).to eq 9
        expect(components[6].index).to eq 9
        expect(components[7].index).to eq 10
        expect(components[8].index).to eq '11+24*i'
        expect(components[9].index).to eq '11+24*i+2*j+k'
        expect(components[10].index).to eq '11+24*i+4+5*(2*j+k)'
        expect(components[11].index).to eq '11+24*i+4+5*(2*j+k)+2*l+m'
        expect(components[12].index).to eq '11+24*i+4+5*(2*j+k)+4'
        expect(components[13].index).to eq '59+2*i+j'
        expect(components[14].index).to eq '59+2*i+j'
        expect(components[15].index).to eq '59+2*i+j'
        expect(components[16].index).to eq '63+4*(2*i+j)'
        expect(components[17].index).to eq '63+4*(2*i+j)'
        expect(components[18].index).to eq '63+4*(2*i+j)+2*k+l'
        expect(components[19].index).to eq 79
      end
    end

    context '引数にオフセットが指定された場合' do
      it '指定されたオフセットでのインデックスを返す' do
        expect(components[0].index(1)).to eq 0
        expect(components[0].index('i')).to eq 0

        expect(components[1].index(1)).to eq 2
        expect(components[1].index('i')).to eq '1+i'

        expect(components[2].index(1)).to eq 7
        expect(components[2].index('i')).to eq 7

        expect(components[3].index(1)).to eq 7
        expect(components[3].index('i')).to eq 7

        expect(components[5].index(1)).to eq 9
        expect(components[5].index('i')).to eq 9

        expect(components[6].index([1, 1])).to eq 9
        expect(components[6].index(['i', 'j'])).to eq 9

        expect(components[8].index(1)).to eq 35
        expect(components[8].index('i')).to eq '11+24*i'

        expect(components[9].index([1, 1])).to eq 36
        expect(components[9].index(['i', 'j'])).to eq '11+24*i+j'

        expect(components[10].index([1, 1])).to eq 44
        expect(components[10].index(['i', 'j'])).to eq '11+24*i+4+5*j'

        expect(components[11].index([1, 1, 1])).to eq 45
        expect(components[11].index(['i', 'j', 'k'])).to eq '11+24*i+4+5*j+k'

        expect(components[12].index([1, 1, 1])).to eq 48
        expect(components[12].index(['i', 'j', 'k'])).to eq '11+24*i+4+5*j+4'

        expect(components[13].index(1)).to eq 60
        expect(components[13].index('i')).to eq '59+i'

        expect(components[14].index([1, 1])).to eq 60
        expect(components[14].index(['i', 'j'])).to eq '59+i'

        expect(components[15].index([1, 1, 1])).to eq 60
        expect(components[15].index(['i', 'j', 'k'])).to eq '59+i'

        expect(components[16].index(1)).to eq 67
        expect(components[16].index('i')).to eq '63+4*i'

        expect(components[17].index([1, 1])).to eq 67
        expect(components[17].index(['i', 'j'])).to eq '63+4*i'

        expect(components[18].index([1, 1, 1])).to eq 68
        expect(components[18].index(['i', 'j', 'k'])).to eq '63+4*i+k'

        expect(components[19].index(1)).to eq 79
        expect(components[19].index('i')).to eq 79
      end
    end
  end

  describe '#local_index' do
    context '配列レジスタファイル/配列レジスタではない場合' do
      it 'nilを返す' do
        expect(components[0].local_index).to be_nil
        expect(components[2].local_index).to be_nil
        expect(components[3].local_index).to be_nil
        expect(components[5].local_index).to be_nil
        expect(components[6].local_index).to be_nil
        expect(components[12].local_index).to be_nil
        expect(components[14].local_index).to be_nil
        expect(components[15].local_index).to be_nil
        expect(components[17].local_index).to be_nil
        expect(components[19].local_index).to be_nil
      end
    end

    context '配列レジスタファイル/配列レジスタの場合' do
      it 'スコープ中でのインデックスを返す' do
        expect(components[1].local_index).to eq '3*i+j'
        expect(components[8].local_index).to eq 'i'
        expect(components[9].local_index).to eq '2*j+k'
        expect(components[10].local_index).to eq '2*j+k'
        expect(components[11].local_index).to eq '2*l+m'
        expect(components[13].local_index).to eq '2*i+j'
        expect(components[16].local_index).to eq '2*i+j'
        expect(components[18].local_index).to eq '2*k+l'
      end
    end
  end

  describe '#local_indices' do
    it '上位階層からの#local_indexの一覧を返す' do
      expect(components[0].local_indices).to match([nil])
      expect(components[1].local_indices).to match(['3*i+j'])
      expect(components[2].local_indices).to match([nil])
      expect(components[3].local_indices).to match([nil, nil])
      expect(components[5].local_indices).to match([nil, nil])
      expect(components[6].local_indices).to match([nil, nil, nil])
      expect(components[8].local_indices).to match(['i'])
      expect(components[9].local_indices).to match(['i', '2*j+k'])
      expect(components[10].local_indices).to match(['i', '2*j+k'])
      expect(components[11].local_indices).to match(['i', '2*j+k', '2*l+m'])
      expect(components[12].local_indices).to match(['i', '2*j+k', nil])
      expect(components[13].local_indices).to match(['2*i+j'])
      expect(components[14].local_indices).to match(['2*i+j', nil])
      expect(components[15].local_indices).to match(['2*i+j', nil, nil])
      expect(components[16].local_indices).to match(['2*i+j'])
      expect(components[17].local_indices).to match(['2*i+j', nil])
      expect(components[18].local_indices).to match(['2*i+j', nil, '2*k+l'])
      expect(components[19].local_indices).to match([nil])
    end
  end

  describe '#loop_variables' do
    context '配列レジスタファイル/配列レジスタ外の場合' do
      it 'nilを返す' do
        expect(components[0].loop_variables).to be_nil
        expect(components[2].loop_variables).to be_nil
        expect(components[3].loop_variables).to be_nil
        expect(components[5].loop_variables).to be_nil
        expect(components[6].loop_variables).to be_nil
        expect(components[19].loop_variables).to be_nil
      end
    end

    context '配列レジスタファイル/配列レジスタの場合' do
      it 'ループ変数の一覧を返す' do
        expect(components[1].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[8].loop_variables).to match([match_identifier('i')])
        expect(components[9].loop_variables).to match([match_identifier('i'), match_identifier('j'), match_identifier('k')])
        expect(components[10].loop_variables).to match([match_identifier('i'), match_identifier('j'), match_identifier('k')])
        expect(components[11].loop_variables).to match([match_identifier('i'), match_identifier('j'), match_identifier('k'), match_identifier('l'), match_identifier('m')])
        expect(components[12].loop_variables).to match([match_identifier('i'), match_identifier('j'), match_identifier('k')])
        expect(components[13].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[14].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[15].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[16].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[17].loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[18].loop_variables).to match([match_identifier('i'), match_identifier('j'), match_identifier('k'), match_identifier('l')])
      end
    end
  end

  describe '#local_loop_variables' do
    context '配列レジスタファイル/配列レジスタではない場合' do
      it 'nilを返す' do
        expect(components[0].local_loop_variables).to be_nil
        expect(components[2].local_loop_variables).to be_nil
        expect(components[3].local_loop_variables).to be_nil
        expect(components[5].local_loop_variables).to be_nil
        expect(components[6].local_loop_variables).to be_nil
        expect(components[12].local_loop_variables).to be_nil
        expect(components[14].local_loop_variables).to be_nil
        expect(components[15].local_loop_variables).to be_nil
        expect(components[19].local_loop_variables).to be_nil
      end
    end

    context '配列レジスタファイル/配列レジスタの場合' do
      it 'スコープ中のループ変数の一覧を返す' do
        expect(components[1].local_loop_variables).to match([match_identifier('i'), match_identifier('j')])
        expect(components[8].local_loop_variables).to match([match_identifier('i')])
        expect(components[9].local_loop_variables).to match([match_identifier('j'), match_identifier('k')])
        expect(components[11].local_loop_variables).to match([match_identifier('l'), match_identifier('m')])
        expect(components[18].local_loop_variables).to match([match_identifier('k'), match_identifier('l')])
      end
    end
  end
end
