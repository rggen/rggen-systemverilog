# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RTL do
  include_context 'clean-up builder'

  let(:builder) { RgGen.builder }

  describe '既定セットアップ' do
    before do
      @original_builder = RgGen.builder
      RgGen.builder(RgGen::Core::Builder.create)
    end

    after do
      RgGen.builder(@original_builder)
    end

    it 'フィーチャーの有効化を行う' do
      expect(RgGen::SystemVerilog::RTL.plugin_spec).to receive(:activate).with(equal(builder))
      expect(builder).to receive(:enable).with(:global, [:array_port_format])
      expect(builder).to receive(:enable).with(:register_block, [:sv_rtl_top, :protocol])
      expect(builder).to receive(:enable).with(:register_block, :protocol, [:apb, :axi4lite, :wishbone])
      expect(builder).to receive(:enable).with(:register_file, [:sv_rtl_top])
      expect(builder).to receive(:enable).with(:register, [:sv_rtl_top])
      expect(builder).to receive(:enable).with(:bit_field, [:sv_rtl_top])
      builder.load_plugins(['rggen/systemverilog/rtl/setup'], true)
    end
  end
end
