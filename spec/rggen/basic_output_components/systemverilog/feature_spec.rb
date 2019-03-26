# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::SystemVerilog
  describe Feature do
    let(:configuration) do
      RgGen::Core::Configuration::Component.new(nil)
    end

    let(:register_map) do
      RgGen::Core::RegisterMap::Component.new(nil, configuration)
    end

    let(:component) do
      RgGen::Core::OutputBase::Component.new(nil, configuration, register_map)
    end

    def create_feature(&body)
      Class.new(Feature, &body).new(component, :foo) do |f|
        component.add_feature(f)
      end
    end

    it 'ERB形式のテンプレートを処理できる' do
      template_path = File.join(__dir__, 'foo.erb')
      allow(File).to receive(:binread).with(template_path).and_return('<%= object_id %><%= foo %>')

      feature = create_feature do
        main_code :test, from_template: template_path
        def foo; 'foo!'; end
      end

      expect(feature.generate_code(:main_code, :test)).to match_string("#{feature.object_id}foo!")
    end
  end
end
