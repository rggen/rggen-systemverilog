# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RgGen::SystemVerilog::Common::Utility::ModuleDefinition do
  include RgGen::SystemVerilog::Common::Utility

  let(:packages) { [:foo_pkg, :bar_pkg] }

  let(:parameters) do
    [:FOO, :BAR].map.with_index do |name, i|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
        :parameter, name: name, parameter_type: :parameter, data_type: :int, default: i
      ).declaration
    end
  end

  let(:ports) do
    [[:i_foo, :input], [:o_bar, :output]].map do |name, direction|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
        :argument, name: name, direction: direction, data_type: :logic
      ).declaration
    end
  end

  let(:variables) do
    [:foo, :bar].map do |name|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
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
      module_definition(:foo) do |m|
        m.package_import packages[0]
      end
    ).to match_string(<<~'MODULE')
      module foo
        import foo_pkg::*;
      ();
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.package_imports packages
      end
    ).to match_string(<<~'MODULE')
      module foo
        import foo_pkg::*,
               bar_pkg::*;
      ();
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.parameters parameters
      end
    ).to match_string(<<~'MODULE')
      module foo #(
        parameter int FOO = 0,
        parameter int BAR = 1
      )();
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.ports ports
      end
    ).to match_string(<<~'MODULE')
      module foo (
        input logic i_foo,
        output logic o_bar
      );
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.variables variables
      end
    ).to match_string(<<~'MODULE')
      module foo ();
        logic foo;
        logic bar;
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.body { 'assign foo = 0;' }
        m.body { |code| code << 'assign bar = 1;' }
      end
    ).to match_string(<<~'MODULE')
      module foo ();
        assign foo = 0;
        assign bar = 1;
      endmodule
    MODULE

    expect(
      module_definition(:foo) do |m|
        m.package_imports packages
        m.parameters parameters
        m.ports ports
        m.variables variables
        m.body { 'assign foo = 0;' }
        m.body { |code| code << 'assign bar = 1;' }
      end
    ).to match_string(<<~'MODULE')
      module foo
        import foo_pkg::*,
               bar_pkg::*;
      #(
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
