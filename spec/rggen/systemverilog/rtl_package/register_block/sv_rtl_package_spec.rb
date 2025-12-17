# frozen_string_literal: true

RSpec.describe 'register_block/sv_rtl_package' do
  include_context 'sv rtl package common'
  include_context 'clean-up builder'

  before(:all) do
    RgGen.enable_all
  end

  describe '#write_file' do
    before do
      allow(FileUtils).to receive(:mkpath)
    end

    let(:configuration) do
      file = ['config.json', 'config.toml', 'config.yml'].sample
      path = File.join(RGGEN_SAMPLE_DIRECTORY, file)
      build_configuration_factory(RgGen.builder, false).create([path])
    end

    let(:register_map) do
      file_0 = ['block_0.rb', 'block_0.toml', 'block_0.yml', 'block_0.xlsx', 'block_0.ods'].sample
      file_1 = ['block_1.rb', 'block_1.toml', 'block_1.yml'].sample
      path = [file_0, file_1].map { |file| File.join(RGGEN_SAMPLE_DIRECTORY, file) }
      build_register_map_factory(RgGen.builder, false).create(configuration, path)
    end

    let(:sv_rtl_package) do
      build_sv_rtl_package_factory(RgGen.builder).create(configuration, register_map).register_blocks
    end

    let(:expected_code) do
      [
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_0_rtl_pkg.sv'),
        File.join(RGGEN_SAMPLE_DIRECTORY, 'block_1_rtl_pkg.sv')
      ].map { |path| File.binread(path) }
    end

    it 'RTL用のパッケージを出力する' do
      sv_rtl_package
      expected_code
      expect {
        sv_rtl_package[0].write_file('foo')
      }.to write_file(match_string('foo/block_0_rtl_pkg.sv'), expected_code[0])

      expect {
        sv_rtl_package[1].write_file('bar')
      }.to write_file(match_string('bar/block_1_rtl_pkg.sv'), expected_code[1])
    end
  end
end
