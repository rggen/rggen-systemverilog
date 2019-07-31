# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe DataObject do
    def data_object(name, &block)
      DataObject.new([:variable, :argument, :parameter].sample, name: name, &block)
    end

    def variable(name, &block)
      DataObject.new(:variable, name: name, &block)
    end

    def argument(name, direction, &block)
      DataObject.new(:argument, name: name, direction: direction, &block)
    end

    def parameter(name, parameter_type, &block)
      DataObject.new(:parameter, name: name, parameter_type: parameter_type, &block)
    end

    describe '#declaration' do
      context '変数の場合' do
        it '変数/信号宣言を返す' do
          expect(variable('foo') { |d| d.data_type :bit }).to match_declaration('bit foo')
          expect(variable('foo') { |d| d.data_type :logic }).to match_declaration('logic foo')
          expect(variable('foo') { |d| d.data_type :wire }).to match_declaration('wire foo')
          expect(variable('foo') { |d| d.data_type :reg }).to match_declaration('reg foo')

          expect(variable('foo') { |d| d.data_type :bit; d.width nil }).to match_declaration('bit foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 1 }).to match_declaration('bit foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2 }).to match_declaration('bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 'WIDTH' }).to match_declaration('bit [WIDTH-1:0] foo')

          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size nil }).to match_declaration('bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [] }).to match_declaration('bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2] }).to match_declaration('bit [1:0][1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3] }).to match_declaration('bit [1:0][2:0][1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :packed }).to match_declaration('bit [1:0][2:0][1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 'WIDTH'; d.array_size [2, 3]; d.array_format :packed }).to match_declaration('bit [1:0][2:0][WIDTH-1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :unpacked }).to match_declaration('bit [1:0] foo[2][3]')
          expect(variable('foo') { |d| d.data_type :bit; d.width 'WIDTH'; d.array_size [2, 3]; d.array_format :unpacked }).to match_declaration('bit [WIDTH-1:0] foo[2][3]')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :serialized }).to match_declaration('bit [11:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 'WIDTH'; d.array_size [2, 3]; d.array_format :serialized }).to match_declaration('bit [WIDTH*2*3-1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 'WIDTH'; d.array_size ['ROW_SIZE', 3]; d.array_format :serialized }).to match_declaration('bit [WIDTH*ROW_SIZE*3-1:0] foo')

          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.random true }).to match_declaration('rand bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.random false }).to match_declaration('bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.random :rand }).to match_declaration('rand bit [1:0] foo')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.random :randc }).to match_declaration('randc bit [1:0] foo')

          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.default 3 }).to match_declaration('bit [1:0] foo = 3')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.default '2\'h3' }).to match_declaration('bit [1:0] foo = 2\'h3')
          expect(variable('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2]; d.array_format :unpacked; d.default '\'{2, 3}' }).to match_declaration('bit [1:0] foo[2] = \'{2, 3}')
        end
      end

      context '引数の場合' do
        it '引数宣言を返す' do
          expect(argument('foo', :input)).to match_declaration('input foo')
          expect(argument('foo', :output)).to match_declaration('output foo')
          expect(argument('foo', :inout)).to match_declaration('inout foo')

          expect(argument('foo', :input) { |a| a.width nil }).to match_declaration('input foo')
          expect(argument('foo', :input) { |a| a.width 1 }).to match_declaration('input foo')
          expect(argument('foo', :input) { |a| a.width 2 }).to match_declaration('input [1:0] foo')
          expect(argument('foo', :input) { |a| a.width 'WIDTH' }).to match_declaration('input [WIDTH-1:0] foo')

          expect(argument('foo', :input) { |a| a.data_type :bit }).to match_declaration('input bit foo')
          expect(argument('foo', :input) { |a| a.width 2; a.data_type :bit }).to match_declaration('input bit [1:0] foo')
          expect(argument('foo', :input) { |a| a.width 'WIDTH'; a.data_type :bit }).to match_declaration('input bit [WIDTH-1:0] foo')

          expect(argument('foo', :input) { |a| a.width 2; a.array_size nil }).to match_declaration('input [1:0] foo')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [] }).to match_declaration('input [1:0] foo')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [2] }).to match_declaration('input [1:0][1:0] foo')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [2, 3] }).to match_declaration('input [1:0][2:0][1:0] foo')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [2, 3]; a.array_format :packed }).to match_declaration('input [1:0][2:0][1:0] foo')
          expect(argument('foo', :input) { |a| a.width 'WIDTH'; a.array_size [2, 3]; a.array_format :packed }).to match_declaration('input [1:0][2:0][WIDTH-1:0] foo')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [2, 3]; a.array_format :unpacked }).to match_declaration('input [1:0] foo[2][3]')
          expect(argument('foo', :input) { |a| a.width 'WIDTH'; a.array_size [2, 3]; a.array_format :unpacked }).to match_declaration('input [WIDTH-1:0] foo[2][3]')
          expect(argument('foo', :input) { |a| a.width 2; a.array_size [2, 3]; a.array_format :serialized }).to match_declaration('input [11:0] foo')
          expect(argument('foo', :input) { |a| a.width 'WIDTH'; a.array_size [2, 3]; a.array_format :serialized }).to match_declaration('input [WIDTH*2*3-1:0] foo')
          expect(argument('foo', :input) { |a| a.width 'WIDTH'; a.array_size ['ROW_SIZE', 3]; a.array_format :serialized }).to match_declaration('input [WIDTH*ROW_SIZE*3-1:0] foo')
        end
      end

      context 'パラメータの場合' do
        it 'パラメータ宣言を返す' do
          expect(parameter('foo', :parameter) { |p| p.default 0 }).to match_declaration('parameter foo = 0')
          expect(parameter('foo', :localparam) { |p| p.default 0 }).to match_declaration('localparam foo = 0')

          expect(parameter('foo', :parameter) { |p| p.width nil; p.default 0 }).to match_declaration('parameter foo = 0')
          expect(parameter('foo', :parameter) { |p| p.width 1; p.default 0 }).to match_declaration('parameter foo = 0')
          expect(parameter('foo', :parameter) { |p| p.width 2; p.default 0 }).to match_declaration('parameter [1:0] foo = 0')
          expect(parameter('foo', :parameter) { |p| p.width 'WIDTH'; p.default 0 }).to match_declaration('parameter [WIDTH-1:0] foo = 0')

          expect(parameter('foo', :parameter) { |p| p.data_type :bit; p.default 0 }).to match_declaration('parameter bit foo = 0')
          expect(parameter('foo', :parameter) { |p| p.width 2; p.data_type :bit; p.default 0 }).to match_declaration('parameter bit [1:0] foo = 0')
          expect(parameter('foo', :parameter) { |p| p.width 'WIDTH'; p.data_type :bit; p.default 0 }).to match_declaration('parameter bit [WIDTH-1:0] foo = 0')
        end
      end
    end

    describe '#identifier' do
      it '自身の識別子を返す' do
        expect(data_object('foo') { |d| d.data_type :bit } ).to match_identifier 'foo'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2 } ).to match_identifier 'foo'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :packed } ).to match_identifier 'foo'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :packed }.identifier[[:i, :j]] ).to match_identifier 'foo[i][j]'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :unpacked } ).to match_identifier 'foo'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :unpacked }.identifier[[:i, :j]] ).to match_identifier 'foo[i][j]'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :serialized } ).to match_identifier 'foo'
        expect(data_object('foo') { |d| d.data_type :bit; d.width 2; d.array_size [2, 3]; d.array_format :serialized }.identifier[[:i, :j]] ).to match_identifier 'foo[2*(3*i+j)+:2]'
      end
    end
  end
end
