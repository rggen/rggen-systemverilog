# frozen_string_literal: true

require 'rggen/systemverilog/rtl'

RgGen.setup RgGen::SystemVerilog::RTL do |builder|
  builder.enable :global, [
    :array_port_format, :fold_sv_interface_port
  ]
  builder.enable :register_block, [:sv_rtl_top, :protocol]
  builder.enable :register_block, :protocol, [:apb, :axi4lite]
  builder.enable :register_file, [:sv_rtl_top]
  builder.enable :register, [:sv_rtl_top]
  builder.enable :bit_field, [:sv_rtl_top]
end
