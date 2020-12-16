# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::RAL do
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
      expect(RgGen::SystemVerilog::RAL.plugin_spec).to receive(:activate).with(equal(builder))
      expect(builder).to receive(:enable).with(:register_block, [:sv_ral_model, :sv_ral_package])
      expect(builder).to receive(:enable).with(:register_file, [:sv_ral_model])
      builder.load_plugins(['rggen/systemverilog/ral/setup'], true)
    end
  end
end
