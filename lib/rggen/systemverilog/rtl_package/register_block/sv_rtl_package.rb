# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :sv_rtl_package) do
  sv_rtl_package do
    write_file '<%= package_name %>.sv' do |file|
      file.body { sv_rtl_package_definition }
    end

    private

    def sv_rtl_package_definition
      package_definition(package_name) do |package|
        package.parameters parameters
      end
    end

    def package_name
      "#{register_block.name}_rtl_pkg"
    end

    def parameters
      register_block.declarations[:parameter]
    end
  end
end
