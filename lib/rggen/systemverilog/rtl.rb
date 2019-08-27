# frozen_string_literal: true

require_relative 'common'
require_relative 'rtl/feature'

module RgGen
  module SystemVerilog
    module RTL
      FEATURES = [
        'rtl/bit_field/sv_rtl_top',
        'rtl/bit_field/type',
        'rtl/bit_field/type/rc_w0c_w1c',
        'rtl/bit_field/type/reserved',
        'rtl/bit_field/type/ro',
        'rtl/bit_field/type/rof',
        'rtl/bit_field/type/rs_w0s_w1s',
        'rtl/bit_field/type/rw_wo',
        'rtl/bit_field/type/rwc_rwe_rwl',
        'rtl/bit_field/type/w0trg_w1trg',
        'rtl/global/array_port_format',
        'rtl/global/fold_sv_interface_port',
        'rtl/register/sv_rtl_top',
        'rtl/register/type',
        'rtl/register/type/external',
        'rtl/register/type/indirect',
        'rtl/register_block/protocol',
        'rtl/register_block/protocol/apb',
        'rtl/register_block/protocol/axi4lite',
        'rtl/register_block/sv_rtl_top'
      ].freeze

      def self.register_component(builder)
        Common.register_component(builder, :sv_rtl, Feature)
      end

      def self.load_features
        Common.load_features(FEATURES, __dir__)
      end
    end
  end
end
