# frozen_string_literal: true

RgGen.define_list_feature(:bit_field, :type) do
  sv_ral do
    base_feature do
      define_helpers do
        attr_setter :access

        def model_name(name = nil, &block)
          @model_name = name || block || @model_name
          @model_name
        end
      end

      export :access
      export :model_name
      export :constructors

      build do
        variable :ral_model, {
          name: bit_field.name, data_type: model_name,
          array_size: array_size, random: true
        }
      end

      def access
        (helper.access || bit_field.type).to_s.upcase
      end

      def model_name
        name = helper.model_name
        name&.is_a?(Proc) && instance_eval(&name) || name || :rggen_ral_field
      end

      def constructors
        (bit_field.sequence_size&.times || [nil]).map do |index|
          macro_call(:rggen_ral_create_field, arguments(index))
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
