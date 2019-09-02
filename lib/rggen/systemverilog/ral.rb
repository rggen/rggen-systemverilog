# frozen_string_literal: true

require_relative 'common'
require_relative 'ral/feature'

module RgGen
  module SystemVerilog
    module RAL
      FEATURES = [
        'ral/bit_field/type',
        'ral/bit_field/type/reserved_rof',
        'ral/bit_field/type/rwc_rws',
        'ral/bit_field/type/rwe_rwl',
        'ral/bit_field/type/w0trg_w1trg',
        'ral/register/type',
        'ral/register/type/external',
        'ral/register/type/indirect',
        'ral/register_block/sv_ral_package'
      ].freeze

      def self.version
        SystemVerilog::VERSION
      end

      def self.register_component(builder)
        Common.register_component(builder, :sv_ral, Feature)
      end

      def self.load_features
        Common.load_features(FEATURES, __dir__)
      end

      def self.default_setup(builder)
        register_component(builder)
        load_features
      end
    end
  end
end
