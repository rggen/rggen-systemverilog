# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RAL do
  include_context 'clean-up builder'

  let(:builder) { RgGen.builder }

  describe '.version' do
    it 'RgGen::SystemVerilogと同じバージョンを返す' do
      expect(RgGen::SystemVerilog::RAL.version).to eq RgGen::SystemVerilog::VERSION
    end
  end

  describe '.default_setup' do
    it '.register_component/.load_featureを呼び出す' do
      expect(RgGen::SystemVerilog::RAL).to receive(:register_component)
      expect(RgGen::SystemVerilog::RAL).to receive(:load_features)
      RgGen::SystemVerilog::RAL.default_setup(builder)
    end
  end

  describe '既定セットアップ' do
    before do
      @original_builder = RgGen.builder
      RgGen.builder(RgGen::Core::Builder.create)
    end

    after do
      RgGen.builder(@original_builder)
    end

    it 'フィーチャーの有効化を行う' do
      expect(builder).to receive(:enable).with(:register_block, [:sv_ral_model, :sv_ral_package])
      expect(builder).to receive(:enable).with(:register_file, [:sv_ral_model])
      require 'rggen/systemverilog/ral/setup'
      builder.activate_plugins
    end
  end
end
