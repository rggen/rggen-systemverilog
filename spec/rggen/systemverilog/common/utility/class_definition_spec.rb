# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Utility::ClassDefinition do
  include RgGen::SystemVerilog::Common::Utility

  let(:parameters) do
    [:FOO, :BAR].map.with_index do |name, i|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
        :parameter, name: name, data_type: :int, default: i
      ).declaration
    end
  end

  let(:variables) do
    [:fizz, :buzz].map do |name|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
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
      class_definition(:foo) do |c|
        c.parameters parameters
      end
    ).to match_string(<<~'CLASS')
      class foo #(
        int FOO = 0,
        int BAR = 1
      );
      endclass
    CLASS

    expect(
      class_definition(:foo) do |c|
        c.base :bar
      end
    ).to match_string(<<~'CLASS')
      class foo extends bar;
      endclass
    CLASS

    expect(
      class_definition(:foo) do  |c|
        c.variables variables
      end
    ).to match_string(<<~'CLASS')
      class foo;
        rand bit fizz;
        rand bit buzz;
      endclass
    CLASS

    expect(
      class_definition(:foo) do |c|
        c.body { 'fizz = 0;' }
        c.body { |code| code << 'buzz = 1;' }
      end
    ).to match_string(<<~'CLASS')
      class foo;
        fizz = 0;
        buzz = 1;
      endclass
    CLASS

    expect(
      class_definition(:foo) do |c|
        c.body { 'fizz = 0;' }
        c.body { |code| code << 'buzz = 1;' }
        c.variables variables
        c.parameters parameters
        c.base :bar
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
