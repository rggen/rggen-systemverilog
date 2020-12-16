# frozen_string_literal: true

require_relative 'common'
require_relative 'rtl/feature'
require_relative 'rtl/partial_sum'
require_relative 'rtl/register_index'
require_relative 'rtl/register_type'
require_relative 'rtl/indirect_index'
require_relative 'rtl/bit_field_index'

module RgGen
  module SystemVerilog
    module RTL
      extend Core::Plugin

      setup_plugin :'rggen-sv-rtl' do |plugin|
        plugin.version SystemVerilog::VERSION

        plugin.register_component :sv_rtl do
          component Common::Component, Common::ComponentFactory
          feature Feature, Common::FeatureFactory
        end

        plugin.files [
          'rtl/bit_field/sv_rtl_top',
          'rtl/bit_field/type',
          'rtl/bit_field/type/rc_w0c_w1c_wc_woc',
          'rtl/bit_field/type/reserved',
          'rtl/bit_field/type/ro',
          'rtl/bit_field/type/rof',
          'rtl/bit_field/type/rs_w0s_w1s_ws_wos',
          'rtl/bit_field/type/rw_w1_wo_wo1',
          'rtl/bit_field/type/rwc',
          'rtl/bit_field/type/rwe',
          'rtl/bit_field/type/rwl',
          'rtl/bit_field/type/rws',
          'rtl/bit_field/type/w0crs_w1crs_wcrs',
          'rtl/bit_field/type/w0src_w1src_wsrc',
          'rtl/bit_field/type/w0t_w1t',
          'rtl/bit_field/type/w0trg_w1trg',
          'rtl/bit_field/type/wrc_wrs',
          'rtl/global/array_port_format',
          'rtl/global/fold_sv_interface_port',
          'rtl/register/sv_rtl_top',
          'rtl/register/type',
          'rtl/register/type/external',
          'rtl/register/type/indirect',
          'rtl/register_block/protocol',
          'rtl/register_block/protocol/apb',
          'rtl/register_block/protocol/axi4lite',
          'rtl/register_block/sv_rtl_top',
          'rtl/register_file/sv_rtl_top'
        ]
      end
    end
  end
end
