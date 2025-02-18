# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :sv_ral_model) do
  sv_ral do
    include RgGen::SystemVerilog::RAL::RegisterCommon

    export :constructors

    build do
      variable :ral_model, {
        name: register_file.name, data_type: model_name,
        array_size: register_file.array_size, random: true
      }
    end

    def constructors
      array_indexes.map.with_index(&method(:constructor_code))
    end

    main_code :ral_package do
      class_definition(model_name) do |sv_class|
        sv_class.base 'rggen_ral_reg_file'
        sv_class.variables variables
        sv_class.body { process_template }
      end
    end

    private

    def model_name
      "#{register_file.full_name('_')}_reg_file_model"
    end

    def constructor_code(array_index, index)
      macro_call(:rggen_ral_create_reg_file, arguments(array_index, index))
    end

    def arguments(array_index, index)
      [
        ral_model[array_index], array(array_index), array(register_file.array_size),
        offset_address(index), string(hdl_path(array_index))
      ]
    end

    def variables
      register_file.declarations[:variable]
    end

    def byte_width
      register_block.byte_width
    end

    def child_model_constructors
      register_file.children.flat_map(&:constructors)
    end
  end
end
