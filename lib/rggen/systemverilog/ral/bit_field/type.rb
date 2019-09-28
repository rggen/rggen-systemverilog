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
        variable :register, :ral_model, {
          name: bit_field.name,
          data_type: model_name,
          array_size: array_size,
          random: true
        }
      end

      def access
        (helper.access || bit_field.type).to_s.upcase
      end

      def model_name
        if helper.model_name&.is_a?(Proc)
          instance_eval(&helper.model_name)
        else
          helper.model_name || :rggen_ral_field
        end
      end

      def constructors
        (bit_field.sequence_size&.times || [nil]).map do |index|
          macro_call(
            :rggen_ral_create_field_model, arguments(index)
          )
        end
      end

      private

      def array_size
        Array(bit_field.sequence_size)
      end

      def arguments(index)
        [
          ral_model[index], bit_field.lsb(index), bit_field.width,
          access, volatile, reset_value, valid_reset
        ]
      end

      def volatile
        bit_field.volatile? && 1 || 0
      end

      def reset_value
        hex(bit_field.initial_value, bit_field.width)
      end

      def valid_reset
        bit_field.initial_value? && 1 || 0
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
