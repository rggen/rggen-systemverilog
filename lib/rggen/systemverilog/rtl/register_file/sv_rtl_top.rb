# frozen_string_literal: true

RgGen.define_simple_feature(:register_file, :sv_rtl_top) do
  sv_rtl do
    include RgGen::SystemVerilog::RTL::RegisterIndex
  end
end
