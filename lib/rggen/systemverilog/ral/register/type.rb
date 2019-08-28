# frozen_string_literal: true

RgGen.define_list_feature(:register, :type) do
  sv_ral do
    base_feature do
      define_helpers do
        def model_name(&body)
          @model_name = body if block_given?
          @model_name
        end

        def offset_address(&body)
          @offset_address = body if block_given?
          @offset_address
        end

        def unmapped
          @unmapped = true
        end

        def unmapped?
          !@unmapped.nil?
        end

        def constructor(&body)
          @constructor = body if block_given?
          @constructor
        end
      end

      export :constructors

      build do
        variable :register_block, :ral_model, {
          name: register.name,
          data_type: model_name,
          array_size: register.array_size,
          random: true
        }
      end

      def constructors
        (array_index_list || [nil]).map.with_index do |array_index, i|
          constructor_code(array_index, i)
        end
      end

      private

      def model_name
        if helper.model_name
          instance_eval(&helper.model_name)
        else
          "#{register.name}_reg_model"
        end
      end

      def array_index_list
        (register.array? || nil) &&
          begin
            index_table = register.array_size.map { |size| (0...size).to_a }
            index_table[0].product(*index_table[1..-1])
          end
      end

      def constructor_code(array_index, index)
        if helper.constructor
          instance_exec(array_index, index, &helper.constructor)
        else
          macro_call(
            :rggen_ral_create_reg_model, arguments(array_index, index)
          )
        end
      end

      def arguments(array_index, index)
        [
          ral_model[array_index], array(array_index), offset_address(index),
          access_rights, unmapped, hdl_path(array_index)
        ]
      end

      def offset_address(index = 0)
        address =
          if helper.offset_address
            instance_exec(index, &helper.offset_address)
          else
            register.offset_address + register.byte_width * index
          end
        hex(address, register_block.local_address_width)
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

      def unmapped
        helper.unmapped? && 1 || 0
      end

      def hdl_path(array_index)
        [
          "g_#{register.name}",
          *Array(array_index).map { |i| "g[#{i}]" },
          'u_register'
        ].join('.')
      end

      def variables
        register.declarations(:register, :variable)
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
      def select_feature(_configuration, register)
        target_features[register.type]
      end
    end
  end
end
