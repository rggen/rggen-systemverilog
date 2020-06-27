# frozen_string_literal: true

RSpec.describe 'register_block/sv_rtl_top' do
  include_context 'sv rtl common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable(:global, [:bus_width, :address_width, :array_port_format, :fold_sv_interface_port])
    RgGen.enable(:register_block, [:name, :byte_size])
    RgGen.enable(:register_file, [:name, :offset_address, :size])
    RgGen.enable(:register, [:name, :offset_address, :size, :type])
    RgGen.enable(:register, :type, [:external, :indirect])
    RgGen.enable(:bit_field, [:name, :bit_assignment, :type, :initial_value, :reference])
    RgGen.enable(:bit_field, :type, [:rc, :reserved, :ro, :rof, :rs, :rw, :rwc, :rwe, :rwl, :rws, :w0c, :w1c, :w0s, :w1s, :w0crs, :w1, :w1crs, :w0src, :w1src, :w0trg, :w1trg, :wo, :wo1])
    RgGen.enable(:register_block, [:sv_rtl_top, :protocol])
    RgGen.enable(:register_block, :protocol, :apb)
    RgGen.enable(:register_file, :sv_rtl_top)
    RgGen.enable(:register, :sv_rtl_top)
    RgGen.enable(:bit_field, :sv_rtl_top)
  end

  def create_register_block(&body)
    create_sv_rtl(&body).register_blocks.first
  end

  let(:bus_width) { default_configuration.bus_width }

  let(:address_width) { 8 }

  describe 'clock/reset' do
    it 'clock/resetを持つ' do
      register_block = create_register_block { name 'block_0'; byte_size 256 }
      expect(register_block)
        .to have_port(:register_block, :clock) { |p| p.name 'i_clk'; p.direction :input; p.data_type :logic; p.width 1; }
      expect(register_block)
        .to have_port(:register_block, :reset) { |p| p.name 'i_rst_n'; p.direction :input; p.data_type :logic; p.width 1; }
    end
  end

  describe 'register_if' do
    it 'レジスタの個数分のrggen_register_ifのインスタンスを持つ' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      expect(register_block).to have_interface(
        :register_block, :register_if,
        name: 'register_if', interface_type: 'rggen_register_if',
        parameter_values: [address_width, bus_width, 1 * bus_width], array_size: [1]
      )

      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          size [2, 4]
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      expect(register_block).to have_interface(
        :register_block, :register_if,
        name: 'register_if', interface_type: 'rggen_register_if',
        parameter_values: [address_width, bus_width, 1 * bus_width], array_size: [8]
      )

      register_block = create_register_block do
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
          bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
        end
        register do
          name 'register_2'
          offset_address 0x20
          bit_field { name 'bit_field_0'; bit_assignment lsb: 64; type :rw; initial_value 0 }
        end
      end
      expect(register_block).to have_interface(
        :register_block, :register_if,
        name: 'register_if', interface_type: 'rggen_register_if',
        parameter_values: [address_width, bus_width, 3 * bus_width], array_size: [3]
      )

      register_block = create_register_block do
        name 'block_0'
        byte_size 256

        register_file do
          name 'register_file_0'
          register do
            name 'register_0'
            bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
          end
          register do
            name 'register_1'
            size [2, 2]
            bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
          end
        end

        register_file do
          name 'register_file_1'
          size [2, 2]
          register_file do
            name 'register_file_0'
            register do
              name 'register_0'
              bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
            end
            register do
              name 'register_1'
              size [2, 2]
              bit_field { name 'bit_field_0'; bit_assignment lsb: 32; type :rw; initial_value 0 }
            end
          end
        end
      end
      expect(register_block).to have_interface(
        :register_block, :register_if,
        name: 'register_if', interface_type: 'rggen_register_if',
        parameter_values: [address_width, bus_width, 2 * bus_width], array_size: [25]
      )
    end

    specify '内部信号\'value\'を参照できる' do
      register_block = create_register_block do
        name 'block_0'
        byte_size 256
        register do
          name 'register_0'
          offset_address 0x00
          bit_field { name 'bit_field_0'; bit_assignment lsb: 0; type :rw; initial_value 0 }
        end
      end
      expect(register_block.register_if[0].value).to match_identifier('register_if[0].value')
    end
  end

  describe '#write_file' do
    before do
      allow(FileUtils).to receive(:mkpath)
    end

    let(:configuration) do
      file = ['config.yml', 'config.json'].sample
      path = File.join(RGGEN_SAMPLE_DIRECTORY, file)
      build_configuration_factory(RgGen.builder, false).create([path])
    end

    let(:register_map) do
      file_0 = ['block_0.rb', 'block_0.xlsx', 'block_0.yml'].sample
      file_1 = ['block_1.rb', 'block_1.yml'].sample
      path = [file_0, file_1].map { |file| File.join(RGGEN_SAMPLE_DIRECTORY, file) }
      build_register_map_factory(RgGen.builder, false).create(configuration, path)
    end

    let(:register_blocks) do
      build_sv_rtl_factory(RgGen.builder).create(configuration, register_map).register_blocks
    end

    let(:expected_code) do
      [
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_0.sv'),
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_1.sv')
      ].map { |path| File.binread(path) }
    end

    it 'RTLのソースファイルを書き出す' do
      expect {
        register_blocks[0].write_file('foo')
      }.to write_file match_string('foo/block_0.sv'), expected_code[0]

      expect {
        register_blocks[1].write_file('bar')
      }.to write_file match_string('bar/block_1.sv'), expected_code[1]
    end
  end
end
