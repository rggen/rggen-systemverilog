# frozen_string_literal: true

RgGen.define_list_item_feature(:register, :type, :maskable) do
  sv_ral do
    main_code :ral_package do
      class_definition(model_name) do |sv_class|
        sv_class.base 'rggen_ral_maskable_reg'
        sv_class.variables variables
        sv_class.body { model_body }
      end
    end

    private

    def model_body
      process_template(File.join(__dir__, 'default.erb'))
    end
  end
end
