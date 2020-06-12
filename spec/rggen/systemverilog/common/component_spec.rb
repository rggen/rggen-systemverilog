# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Component do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:component) do
    described_class.new(nil, 'component', nil, configuration, register_map)
  end

  def create_child_component
    described_class.new(component, 'component', nil, configuration, register_map) do |child_component|
      component.add_child(child_component)
      yield(child_component)
    end
  end

  def create_feature(component, feature_name, &body)
    Class.new(RgGen::SystemVerilog::RAL::Feature, &body).new(feature_name, nil, component) do |feature|
      feature.build
      component.add_feature(feature)
    end
  end

  describe '#package_imports' do
    before do
      create_feature(component, :foo_feature) do
        build do
          import_package :domain_0, :foo_0_pkg
          import_package :domain_1, :foo_1_pkg
        end
      end

      create_feature(component, :bar_feature) do
        build do
          import_package :domain_0, :bar_0_pkg
          import_package :domain_1, :bar_1_pkg
        end
      end

      create_child_component do |child_component|
        create_feature(child_component, :foo_feature) do
          build do
            import_package :domain_0, :foo_0_pkg
            import_package :domain_1, :foo_1_pkg
          end
        end
        create_feature(child_component, :baz_feature) do
          build do
            import_package :domain_0, :baz_0_pkg
            import_package :domain_1, :baz_1_pkg
          end
        end
      end
    end

    it '配下のフィーチャーでインポート指定されたパッケージ一覧を返す' do
      expect(component.package_imports(:domain_0)).to match([:foo_0_pkg, :bar_0_pkg, :baz_0_pkg])
      expect(component.package_imports(:domain_1)).to match([:foo_1_pkg, :bar_1_pkg, :baz_1_pkg])
    end
  end
end
