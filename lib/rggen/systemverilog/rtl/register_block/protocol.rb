# frozen_string_literal: true

RgGen.define_list_feature(:register_block, :protocol) do
  shared_context do
    def feature_registry(registry)
      feature_registries << registry
    end

    def default_protocol
      available_protocols.first
    end

    def find_protocol(value)
      available_protocols
        .find { value.to_sym.casecmp?(_1) }
    end

    private

    def feature_registries
      @feature_registries ||= []
    end

    def available_protocols
      feature_registries
        .map { |registry| registry.enabled_features(:protocol) }
        .inject(:&)
    end
  end

  configuration do
    base_feature do
      property :protocol
      build { |protocol| @protocol = protocol }
      printable :protocol
    end

    default_feature do
    end

    factory do
      convert_value do |value, position|
        shared_context.find_protocol(value) ||
          (error "unknown protocol: #{value.inspect}", position)
      end

      default_value do |position|
        shared_context.default_protocol ||
          (error 'no protocols are available', position)
      end

      def target_feature_key(data)
        data.value
      end
    end
  end

  register_map do
    base_feature do
      property :protocol, default: -> { configuration.protocol }
      build { |protocol| @protocol = protocol }

      def position
        super || configuration.feature(:protocol).position
      end
    end

    default_feature do
    end

    factory do
      convert_value do |value, position|
        shared_context.find_protocol(value) ||
          (error "unknown protocol: #{value.inspect}", position)
      end

      def target_feature_key(configuration, data)
        data&.value || configuration.protocol
      end
    end
  end

  sv_rtl do
    shared_context.feature_registry(registry)

    base_feature do
      build do
        parameter :address_width, {
          name: 'ADDRESS_WIDTH', data_type: :int, default: local_address_width
        }
        parameter :pre_decode, {
          name: 'PRE_DECODE', data_type: :bit, width: 1, default: 0
        }
        parameter :base_address, {
          name: 'BASE_ADDRESS', data_type: :bit, width: address_width,
          default: all_bits_0
        }
        parameter :error_status, {
          name: 'ERROR_STATUS', data_type: :bit, width: 1, default: 0
        }
        parameter :default_read_data, {
          name: 'DEFAULT_READ_DATA', data_type: :bit, width: bus_width,
          default: all_bits_0
        }
        parameter :insert_slicer, {
          name: 'INSERT_SLICER', data_type: :bit, width: 1, default: 0
        }
      end

      private

      def bus_width
        register_block.bus_width
      end

      def local_address_width
        register_block.local_address_width
      end

      def total_registers
        register_block.total_registers
      end

      def byte_size
        register_block.byte_size
      end

      def clock
        register_block.clock
      end

      def reset
        register_block.reset
      end

      def register_if
        register_block.register_if
      end
    end

    factory do
      def target_feature_key(_configuration, register_block)
        register_block.protocol
      end
    end
  end
end
