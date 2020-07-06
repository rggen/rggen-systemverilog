# frozen_string_literal: true

require 'rggen/systemverilog/ral'

RgGen.setup :'rggen-sv-ral', RgGen::SystemVerilog::RAL do |builder|
  builder.enable :register_block, [:sv_ral_model, :sv_ral_package]
  builder.enable :register_file, [:sv_ral_model]
end
