# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :sv_ral_package) do
  sv_ral do
    write_file '<%= package_name %>.sv' do |file|
      file.body do
        package_definition(package_name) do |package|
          package.package_imports packages
          package.include_files include_files
          package.body do |code|
            register_block.generate_code(code, :ral_package, :bottom_up)
          end
        end
      end
    end

    private

    def package_name
      "#{register_block.name}_ral_pkg"
    end

    def packages
      [
        'uvm_pkg', 'rggen_ral_pkg',
        *register_block.package_imports(:ral_package)
      ]
    end

    def include_files
      ['uvm_macros.svh', 'rggen_ral_macros.svh']
    end
  end
end
