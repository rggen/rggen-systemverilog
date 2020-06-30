# frozen_string_literal: true

RgGen.define_simple_feature(:register_block, :sv_ral_model) do
  sv_ral do
    main_code :ral_package do
      class_definition(model_name) do |sv_class|
        sv_class.base 'rggen_ral_block'
        sv_class.parameters parameters
        sv_class.variables variables
        sv_class.body { process_template }
      end
    end

    private

    def model_name
      "#{register_block.name}_ral_model"
    end

    def parameters
      register_block.declarations[:parameter]
    end

    def variables
      register_block.declarations[:variable]
    end

    def byte_width
      configuration.byte_width
    end

    def child_model_constructors
      register_block.children.flat_map(&:constructors)
    end
  end
end
