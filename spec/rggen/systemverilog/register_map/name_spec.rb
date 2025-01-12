# frozen_string_literal: true

RSpec.describe 'regiter_map/name' do
  include_context 'clean-up builder'
  include_context 'register map common'

  before(:all) do
    RgGen.enable(:register_block, :name)
    RgGen.enable(:register_file, :name)
    RgGen.enable(:register, :name)
    RgGen.enable(:bit_field, :name)
  end

  let(:systemverilog_keywords) do
    [
      'accept_on', 'alias', 'always', 'always_comb', 'always_ff',
      'always_latch', 'and', 'assert', 'assign', 'assume', 'automatic',
      'before', 'begin', 'bind', 'bins', 'binsof', 'bit', 'break', 'buf',
      'bufif0', 'bufif1', 'byte', 'case', 'casex', 'casez', 'cell', 'chandle',
      'checker', 'class', 'clocking', 'cmos', 'config', 'const', 'constraint',
      'context', 'continue', 'cover', 'covergroup', 'coverpoint', 'cross',
      'deassign', 'default', 'defparam', 'design', 'disable', 'dist', 'do',
      'edge', 'else', 'end', 'endcase', 'endchecker', 'endclass', 'endclocking',
      'endconfig', 'endfunction', 'endgenerate', 'endgroup', 'endinterface',
      'endmodule', 'endpackage', 'endprimitive', 'endprogram', 'endproperty',
      'endspecify', 'endsequence', 'endtable', 'endtask', 'enum', 'event',
      'eventually', 'expect', 'export', 'extends', 'extern', 'final', 'first_match',
      'for', 'force', 'foreach', 'forever', 'fork', 'forkjoin', 'function',
      'generate', 'genvar', 'global', 'highz0', 'highz1', 'if', 'iff', 'ifnone',
      'ignore_bins', 'illegal_bins', 'implements', 'implies', 'import', 'incdir',
      'include', 'initial', 'inout', 'input', 'inside', 'instance', 'int',
      'integer', 'interconnect', 'interface', 'intersect', 'join', 'join_any',
      'join_none', 'large', 'let', 'liblist', 'library', 'local', 'localparam',
      'logic', 'longint', 'macromodule', 'matches', 'medium', 'modport',
      'module', 'nand', 'negedge', 'nettype', 'new', 'nexttime', 'nmos',
      'nor', 'noshowcancelled', 'not', 'notif0', 'notif1', 'null', 'or',
      'output', 'package', 'packed', 'parameter', 'pmos', 'posedge', 'primitive',
      'priority', 'program', 'property', 'protected', 'pull0', 'pull1',
      'pulldown', 'pullup', 'pulsestyle_ondetect', 'pulsestyle_onevent',
      'pure', 'rand', 'randc', 'randcase', 'randsequence', 'rcmos', 'real',
      'realtime', 'ref', 'reg', 'reject_on', 'release', 'repeat', 'restrict',
      'return', 'rnmos', 'rpmos', 'rtran', 'rtranif0', 'rtranif1', 's_always',
      's_eventually', 's_nexttime', 's_until', 's_until_with', 'scalared',
      'sequence', 'shortint', 'shortreal', 'showcancelled', 'signed', 'small',
      'soft', 'solve', 'specify', 'specparam', 'static', 'string', 'strong',
      'strong0', 'strong1', 'struct', 'super', 'supply0', 'supply1',
      'sync_accept_on', 'sync_reject_on', 'table', 'tagged', 'task', 'this',
      'throughout', 'time', 'timeprecision', 'timeunit', 'tran', 'tranif0',
      'tranif1', 'tri', 'tri0', 'tri1', 'triand', 'trior', 'trireg', 'type',
      'typedef', 'union', 'unique', 'unique0', 'unsigned', 'until', 'until_with',
      'untyped', 'use', 'uwire', 'var', 'vectored', 'virtual', 'void', 'wait',
      'wait_order', 'wand', 'weak', 'weak0', 'weak1', 'while', 'wildcard',
      'wire', 'with', 'within', 'wor', 'xnor', 'xor'
    ]
  end

  context 'レジスタブロック名がSystemVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      systemverilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block { name keyword }
          end
        }.to raise_register_map_error "systemverilog keyword is not allowed for register block name: #{keyword}"
      end
    end
  end

  context 'レジスタファイル名がSystemVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      systemverilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register_file { name keyword }
            end
          end
        }.to raise_register_map_error "systemverilog keyword is not allowed for register file name: #{keyword}"
      end
    end
  end

  context 'レジスタ名がSystemVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      systemverilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register { name keyword }
            end
          end
        }.to raise_register_map_error "systemverilog keyword is not allowed for register name: #{keyword}"
      end
    end
  end

  context 'ビットフィールド名がSystemVerilogの予約語に一致する場合' do
    it 'RegiterMapErrorを起こす' do
      systemverilog_keywords.each do |keyword|
        expect {
          create_register_map do
            register_block do
              name 'block_0'
              register do
                name 'register_0'
                bit_field { name keyword }
              end
            end
          end
        }.to raise_register_map_error "systemverilog keyword is not allowed for bit field name: #{keyword}"
      end
    end
  end
end
