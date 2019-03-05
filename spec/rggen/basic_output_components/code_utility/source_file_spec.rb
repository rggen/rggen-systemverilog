# frozen_string_literal: true

require 'spec_helper'

module RgGen::BasicOutputComponents::CodeUtility
  describe SourceFile do
    include RgGen::BasicOutputComponents::CodeUtility

    def source_file(&block)
      klass = Class.new(SourceFile) do
        ifndef_keyword  :'`ifndef'
        endif_keyword   :'`endif'
        define_keyword  :'`define'
        include_keyword :'`include'
      end
      klass.new(file, &block).to_code
    end

    let(:file) { 'foo/bar.sv' }

    describe '#file_header' do
      it '#file_headerを挿入する' do
        expect(
          source_file do |f|
            f.file_header { "// #{file_path}" }
          end
        ).to match_string "// foo/bar.sv\n"
      end
    end

    describe '#include_guard' do
      it 'インクルードガードを挿入する' do
        expect(
          source_file do |f|
            f.include_guard
          end
        ).to match_string <<~'CODE'
        `ifndef BAR_SV
        `define BAR_SV
        `endif
        CODE
      end

      context 'ブロックが与えら得れた場合' do
        specify 'ブロックの評価結果がガードマクロの識別子になる' do
          expect(
            source_file do |f|
              f.include_guard { "__#{default_guard_macro}__" }
            end
          ).to match_string <<~'CODE'
          `ifndef __BAR_SV__
          `define __BAR_SV__
          `endif
          CODE
        end
      end
    end

    describe '#include_file' do
      it '指定したファイルをインクルードファイルとして挿入する' do
        expect(
          source_file do |f|
            f.include_file 'fizz.svh'
            f.include_file 'buzz.svh'
          end
        ).to match_string <<~'CODE'
        `include "fizz.svh"
        `include "buzz.svh"
        CODE
      end
    end

    describe '#body' do
      let(:identifiers) do
        [:foo, :bar, :baz]
      end

      it '本体のコードを挿入する' do
        expect(
          source_file do |f|
            f.body { "logic #{identifiers[0]};" }
            f.body { |c| c << "logic #{identifiers[1]};" << nl }
            f.body { |c| c << "logic #{identifiers[2]};" << nl }
          end
        ).to match_string <<~'CODE'
        logic foo;
        logic bar;
        logic baz;
        CODE
      end
    end

    it 'ファイルヘッダー、インクルードガード、インクルードファイル、本体の順でコードを挿入する' do
      expect(
        source_file do |f|
          f.file_header { "// #{file_path}" }
          f.include_guard
          f.include_file 'fizz.svh'
          f.body { 'logic foo;' }
        end
      ).to match_string <<~'CODE'
      // foo/bar.sv
      `ifndef BAR_SV
      `define BAR_SV
      `include "fizz.svh"
      logic foo;
      `endif
      CODE
    end
  end
end
