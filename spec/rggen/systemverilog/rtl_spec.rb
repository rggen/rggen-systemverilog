# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RTL do
  include_context 'clean-up builder'

  let(:builder) { RgGen.builder }

  describe '.version' do
    it 'RgGen::SystemVerilogと同じバージョンを返す' do
      expect(RgGen::SystemVerilog::RTL.version).to eq RgGen::SystemVerilog::VERSION
    end
  end

  describe '.default_setup' do
    it '.register_component/.load_featureを呼び出す' do
      expect(RgGen::SystemVerilog::RTL).to receive(:register_component)
      expect(RgGen::SystemVerilog::RTL).to receive(:load_features)
      RgGen::SystemVerilog::RTL.default_setup(builder)
    end
  end

  describe '既定セットアップ' do
    it 'フィーチャーの有効化を行う' do
      allow(RgGen::SystemVerilog::RTL).to receive(:default_setup)
      expect(builder).to receive(:enable).with(:global, [:array_port_format, :fold_sv_interface_port])
      expect(builder).to receive(:enable).with(:register_block, [:sv_rtl_top, :protocol])
      expect(builder).to receive(:enable).with(:register_block, :protocol, [:apb, :axi4lite])
      expect(builder).to receive(:enable).with(:register, [:sv_rtl_top])
      expect(builder).to receive(:enable).with(:bit_field, [:sv_rtl_top])
      require 'rggen/systemverilog/rtl/setup'
    end
  end
end
