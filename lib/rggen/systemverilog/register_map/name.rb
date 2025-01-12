# frozen_string_literal: true

[:register_block, :register_file, :register, :bit_field].each do |layer|
  RgGen.modify_simple_feature(layer, :name) do
    register_map do
      include RgGen::SystemVerilog::RegisterMap::KeywordChecker
    end
  end
end
