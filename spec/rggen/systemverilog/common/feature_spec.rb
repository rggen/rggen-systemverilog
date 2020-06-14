# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Feature do
  let(:configuration) do
    RgGen::Core::Configuration::Component.new(nil, 'configuration', nil)
  end

  let(:register_map) do
    RgGen::Core::RegisterMap::Component.new(nil, 'register_map', nil, configuration)
  end

  let(:component) do
    create_component(nil, nil)
  end

  let(:components) do
    register_block = create_component(nil, :register_block)
    register_file = create_component(register_block, :register_file)
    register = create_component(register_file, :register)
    bit_field = create_component(register, :bit_field)
    [register_block, register_file, register, bit_field]
  end

  def create_component(parent, layer)
    RgGen::SystemVerilog::Common::Component.new(parent, 'component', layer, configuration, register_map)
  end

  def create_feature(component, &body)
    Class.new(described_class, &body).new(:foo, nil, component) do |f|
      component.add_feature(f)
    end
  end

  describe 'エンティティの定義' do
    let(:feature) do
      create_feature(components[3]) do
        define_entity(:foo_0, :bar_0, :baz_0, -> { register_block })
        def bar_0(data_type, attribute, &block)
          RgGen::SystemVerilog::Common::Utility::DataObject
            .new(:variable, attribute.merge(data_type: :logic), &block)
        end

        define_entity(:foo_1, :bar_1, :baz_1, -> { component })
        def bar_1(data_type, attribute, &block)
          RgGen::SystemVerilog::Common::Utility::DataObject
            .new(:variable, attribute.merge(data_type: :bit), &block)
        end
      end
    end

    specify '定義したエンティティの識別子をハンドル名で参照できる' do
      feature.instance_eval { foo_0(:foo_0_0) }
      feature.instance_eval { foo_0(:foo_0_1, name: 'foofoo_1', width: 2) }
      feature.instance_eval { foo_0(:foo_0_2) { |f| f.name 'foofoo_2'; f.width 3 } }

      expect(feature).to have_identifier(:foo_0_0, 'foo_0_0')
      expect(feature).to have_identifier(:foo_0_1, 'foofoo_1')
      expect(feature).to have_identifier(:foo_0_2, 'foofoo_2')
    end

    specify '定義したエンティティの識別子はコンポーネント経由で参照できる' do
      feature.instance_eval { foo_0(:foo_0_0) }
      feature.instance_eval { foo_0(:foo_0_1, name: 'foofoo_1', width: 2) }
      feature.instance_eval { foo_0(:foo_0_2) { |f| f.name 'foofoo_2'; f.width 3 } }
      components[3].build

      expect(components[3]).to have_identifier(:foo_0_0, 'foo_0_0')
      expect(components[3]).to have_identifier(:foo_0_1, 'foofoo_1')
      expect(components[3]).to have_identifier(:foo_0_2, 'foofoo_2')
    end

    context '宣言追加先の階層が未指定の場合' do
      specify 'エンティティの宣言は、既定の階層に追加される' do
        feature.instance_eval { foo_0(:foo_0_0) }
        feature.instance_eval { foo_0(:foo_0_1, name: 'foofoo_1', width: 2) }
        feature.instance_eval { foo_0(:foo_0_2) { |f| f.name 'foofoo_2'; f.width 3 } }

        expect(components[0]).to have_declaration(:baz_0, 'logic foo_0_0')
        expect(components[0]).to have_declaration(:baz_0, 'logic [1:0] foofoo_1')
        expect(components[0]).to have_declaration(:baz_0, 'logic [2:0] foofoo_2')

        feature.instance_eval { foo_1(:foo_1_0) }
        feature.instance_eval { foo_1(:foo_1_1, name: 'foofoo_4', width: 2) }
        feature.instance_eval { foo_1(:foo_1_2) { |f| f.name 'foofoo_5'; f.width 3 } }

        expect(components[3]).to have_declaration(:baz_1, 'bit foo_1_0')
        expect(components[3]).to have_declaration(:baz_1, 'bit [1:0] foofoo_4')
        expect(components[3]).to have_declaration(:baz_1, 'bit [2:0] foofoo_5')
      end
    end

    context '宣言追加先の階層が指定された場合' do
      specify 'エンティティの宣言は、指定された階層に追加される' do
        feature.instance_eval { foo_0(:foo_0_0, register_file) }
        feature.instance_eval { foo_0(:foo_0_1, register, name: 'foofoo_1', width: 2) }
        feature.instance_eval { foo_0(:foo_0_2, bit_field) { |f| f.name 'foofoo_2'; f.width 3 } }

        expect(components[1]).to have_declaration(:baz_0, 'logic foo_0_0')
        expect(components[2]).to have_declaration(:baz_0, 'logic [1:0] foofoo_1')
        expect(components[3]).to have_declaration(:baz_0, 'logic [2:0] foofoo_2')
      end
    end

    context '引数が4つ以上の場合' do
      it 'ArgumentErrorを起こす' do
        expect {
          feature.instance_eval { foo_0(:foo, :bar, :baz, name: 'foofoo') }
        }.to raise_error ArgumentError, 'wrong number of arguments (given 4, expected 1..3)'

        expect {
          feature.instance_eval { foo_0(:foo, :bar, :baz, :qux, name: 'foofoo') }
        }.to raise_error ArgumentError, 'wrong number of arguments (given 5, expected 1..3)'
      end
    end
  end

  describe '#package_imports' do
    it '#import_package/import_packagesで指定されたパッケージ一覧を返す' do
      feature = create_feature(component) do
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

    feature = create_feature(component) do
      main_code :test, from_template: template_path
      def foo; 'foo!'; end
    end

    code = double('code')
    expect(code).to receive(:<<).with("#{feature.object_id}foo!")

    feature.generate_code(code, :main_code, :test)
  end
end
