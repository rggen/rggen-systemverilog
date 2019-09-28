# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new('configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new('register_map', nil, configuration)
  end

  let(:component) do
    RgGen::Core::OutputBase::Component.new('component', nil, configuration, register_map)
  end

  def create_feature(&body)
    Class.new(described_class, &body).new(:foo, nil, component) do |f|
      component.add_feature(f)
    end
  end

  describe '#package_imports' do
    it '#import_package/import_packagesで指定されたパッケージ一覧を返す' do
      feature = create_feature do
        build do
          import_package :foo, :foo_0_pkg
          import_packages :foo, [:foo_0_pkg, :foo_1_pkg, :foo_2_pkg]
          import_package :bar, :bar_0_pkg
        end
      end
      feature.build

      expect(feature.package_imports(:foo)).to match([:foo_0_pkg, :foo_1_pkg, :foo_2_pkg])
      expect(feature.package_imports(:bar)).to match([:bar_0_pkg])
      expect(feature.package_imports(:baz)).to be_empty
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
