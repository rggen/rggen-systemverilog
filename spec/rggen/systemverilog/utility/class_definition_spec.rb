# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe ClassDefinition do
    include RgGen::SystemVerilog::Utility

    let(:context) { self }

    let(:parameters) do
      [:FOO, :BAR].map.with_index do |name, i|
        DataObject.new(
          :parameter, name: name, data_type: :int, default: i
        ).declaration
      end
    end

    let(:variables) do
      [:fizz, :buzz].map do |name|
        DataObject.new(
          :variable, name: name, data_type: :bit, random: true
        ).declaration
      end
    end

    it 'クラス定義を行うコードを返す' do
      expect(
        class_definition(:foo)
      ).to match_string(<<~'CLASS')
        class foo;
        endclass
      CLASS

      expect(
        class_definition(:foo) do
          parameters context.parameters
        end
      ).to match_string(<<~'CLASS')
        class foo #(
          int FOO = 0,
          int BAR = 1
        );
        endclass
      CLASS

      expect(
        class_definition(:foo) do
          base :bar
        end
      ).to match_string(<<~'CLASS')
        class foo extends bar;
        endclass
      CLASS

      expect(
        class_definition(:foo) do
          variables context.variables
        end
      ).to match_string(<<~'CLASS')
        class foo;
          rand bit fizz;
          rand bit buzz;
        endclass
      CLASS

      expect(
        class_definition(:foo) do
          body { 'fizz = 0;' }
          body { |c| c << 'buzz = 1;' }
        end
      ).to match_string(<<~'CLASS')
        class foo;
          fizz = 0;
          buzz = 1;
        endclass
      CLASS

      expect(
        class_definition(:foo) do
          body { 'fizz = 0;' }
          body { |c| c << 'buzz = 1;' }
          variables context.variables
          parameters context.parameters
          base :bar
        end
      ).to match_string(<<~'CLASS')
        class foo #(
          int FOO = 0,
          int BAR = 1
        ) extends bar;
          rand bit fizz;
          rand bit buzz;
          fizz = 0;
          buzz = 1;
        endclass
      CLASS
    end
  end
end
