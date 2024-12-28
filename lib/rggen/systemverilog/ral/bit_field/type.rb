# frozen_string_literal: true

RgGen.define_list_feature(:bit_field, :type) do
  sv_ral do
    base_feature do
      define_helpers do
        def access(access_type = nil, &)
          attribute_accessor('@access', access_type, &)
        end

        def model_name(name = nil, &)
          attribute_accessor('@model_name', name, &)
        end

        private

        def attribute_accessor(variable_name, value, &block)
          (new_value = value || block) &&
            instance_variable_set(variable_name, new_value)
          instance_variable_get(variable_name)
        end
      end

      export :access
      export :model_name
      export :constructors

      build do
        variable :ral_model, {
          name: bit_field.name, data_type: model_name,
          array_size:, random: true
        }
      end

      def access
        eval_attribute(:access, bit_field.type).to_s.upcase
      end

      def model_name
        eval_attribute(:model_name, 'rggen_ral_field')
      end

      def constructors
        (bit_field.sequence_size&.times || [nil]).map do |index|
          macro_call('rggen_ral_create_field', arguments(index))
        end
      end

      private

      def array_size
        Array(bit_field.sequence_size)
      end

      def arguments(index)
        [
          ral_model[index], bit_field.lsb(index), bit_field.width, string(access),
          volatile, reset_value(index), valid_reset, index || -1, string(reference)
        ]
      end

      def volatile
        bit_field.volatile? && 1 || 0
      end

      def reset_value(index)
        value =
          bit_field.initial_values&.at(index) || bit_field.initial_value || 0
        hex(value, bit_field.width)
      end

      def valid_reset
        bit_field.initial_value? && 1 || 0
      end

      def reference
        if bit_field.reference?
          reference_field = bit_field.reference
          [reference_field.register.full_name('.'), reference_field.name].join('.')
        else
          ''
        end
      end

      def eval_attribute(attribute, default_value)
        value = helper.__send__(attribute)
        value.is_a?(Proc) && instance_eval(&value) || value || default_value
      end
    end

    default_feature do
    end

    factory do
      def target_feature_key(_configuration, bit_field)
        bit_field.type
      end
    end
  end
end
