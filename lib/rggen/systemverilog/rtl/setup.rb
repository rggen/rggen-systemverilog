# frozen_string_literal: true

require 'rggen/systemverilog/rtl'

RgGen.register_plugin RgGen::SystemVerilog::RTL do |builder|
  builder.enable :global, [:array_port_format]
  builder.enable :register_block, [:sv_rtl_top, :protocol]
  builder.enable :register_block, :protocol, [:apb, :axi4lite, :wishbone]
  builder.enable :register_file, [:sv_rtl_top]
  builder.enable :register, [:sv_rtl_top]
  builder.enable :bit_field, [:sv_rtl_top]
end
