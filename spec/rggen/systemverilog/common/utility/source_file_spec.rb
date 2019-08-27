# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Utility::SourceFile do
  it 'SystemVerilogのソースファイルのコードを返す' do
    source_file = described_class.new('foo.sv') do |f|
      f.include_guard
      f.include_file 'bar.svh'
      f.body { "foo = 1;\n" }
    end
    expect(source_file.to_code).to match_string(<<~'CODE')
      `ifndef FOO_SV
      `define FOO_SV
      `include "bar.svh"
      foo = 1;
      `endif
    CODE
  end
end
