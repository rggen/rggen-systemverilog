# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  sv_ral do
    base_feature do
      include RgGen::SystemVerilog::RAL::RegisterCommon

      define_helpers do
        def model_name(&body)
          @model_name = body if block_given?
          @model_name
        end

        def offset_address(&body)
          @offset_address = body if block_given?
          @offset_address
        end

        def constructor(&body)
          @constructor = body if block_given?
          @constructor
        end
      end

      export :constructors

      build do
        variable :ral_model, {
          name: register.name, data_type: model_name,
          array_size: register.array_size, random: true
        }
      end

      def constructors
        array_indexes.map.with_index(&method(:constructor_code))
      end

      private

      def model_name
        if helper.model_name
          instance_eval(&helper.model_name)
        else
          "#{register.full_name('_')}_reg_model"
        end
      end

      def constructor_code(array_index, index)
        if helper.constructor
          instance_exec(array_index, index, &helper.constructor)
        else
          macro_call(:rggen_ral_create_reg, arguments(array_index, index))
        end
      end

      def arguments(array_index, index)
        [
          ral_model[array_index], array(array_index), array(register.array_size),
          offset_address(index), string(access_rights), string(hdl_path(array_index))
        ]
      end

      def access_rights
        if read_only?
          'RO'
        elsif write_only?
          'WO'
        else
          'RW'
        end
      end

      def read_only?
        !register.writable?
      end

      def write_only?
        register.writable? && !register.readable?
      end

      def variables
        register.declarations[:variable]
      end

      def field_model_constructors
        register.bit_fields.flat_map(&:constructors)
      end
    end

    default_feature do
      main_code :ral_package do
        class_definition(model_name) do |sv_class|
          sv_class.base 'rggen_ral_reg'
          sv_class.variables variables
          sv_class.body { model_body }
        end
      end

      private

      def model_body
        process_template(File.join(__dir__, 'type', 'default.erb'))
      end
    end

    factory do
      def target_feature_key(_configuration, register)
        register.type
      end
    end
  end
end
