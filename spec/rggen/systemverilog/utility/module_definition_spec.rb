# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe ModuleDefinition do
    def module_definition(name, &block)
      ModuleDefinition.new(name: name, &block).to_code
    end

    def context
      self
    end

    let(:parameters) do
      [:FOO, :BAR].map.with_index do |name, i|
        DataObject.new(
          :parameter, name: name, parameter_type: :parameter, data_type: :int, default: i
        ).declaration
      end
    end

    let(:ports) do
      [[:i_foo, :input], [:o_bar, :output]].map do |name, direction|
        DataObject.new(
          :argument, name: name, direction: direction, data_type: :logic
        ).declaration
      end
    end

    let(:variables) do
      [:foo, :bar].map do |name|
        DataObject.new(
          :variable, name: name, data_type: :logic
        ).declaration
      end
    end

    it 'モジュール定義を行うコードを返す' do
      expect(
        module_definition(:foo)
      ).to match_string(<<~'MODULE')
        module foo ();
        endmodule
      MODULE

      expect(
        module_definition(:foo) do
          parameters context.parameters
        end
      ).to match_string(<<~'MODULE')
        module foo #(
          parameter int FOO = 0,
          parameter int BAR = 1
        )();
        endmodule
      MODULE

      expect(
        module_definition(:foo) do
          ports context.ports
        end
      ).to match_string(<<~'MODULE')
        module foo (
          input logic i_foo,
          output logic o_bar
        );
        endmodule
      MODULE

      expect(
        module_definition(:foo) do
          variables context.variables
        end
      ).to match_string(<<~'MODULE')
        module foo ();
          logic foo;
          logic bar;
        endmodule
      MODULE

      expect(
        module_definition(:foo) do
          body { 'assign foo = 0;' }
          body { |code| code << 'assign bar = 1;' }
        end
      ).to match_string(<<~'MODULE')
        module foo ();
          assign foo = 0;
          assign bar = 1;
        endmodule
      MODULE

      expect(
        module_definition(:foo) do
          parameters context.parameters
          ports context.ports
          variables context.variables
          body { 'assign foo = 0;' }
          body { |code| code << 'assign bar = 1;' }
        end
      ).to match_string(<<~'MODULE')
        module foo #(
          parameter int FOO = 0,
          parameter int BAR = 1
        )(
          input logic i_foo,
          output logic o_bar
        );
          logic foo;
          logic bar;
          assign foo = 0;
          assign bar = 1;
        endmodule
      MODULE
    end
  end
end
