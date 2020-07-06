# frozen_string_literal: true

RSpec.describe RgGen::SystemVerilog::Common::Utility::LocalScope do
  include RgGen::SystemVerilog::Common::Utility

  let(:parameters) do
    [:BAR, :BAZ].map do |name|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
        :parameter, name: name, parameter_type: :localparam, data_type: :logic, default: 0
      ).declaration
    end
  end

  let(:variables) do
    [:bar, :baz].map do |name|
      RgGen::SystemVerilog::Common::Utility::DataObject.new(
        :variable, name: name, data_type: :logic
      ).declaration
    end
  end

  let(:loop_size) do
    { i: 1, j: 2, k: 3 }
  end

  it 'ローカススコープを定義するコードを返す' do
    expect(
      local_scope(:foo)
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.top_scope
      end
    ).to match_string(<<~'SCOPE')
      generate if (1) begin : foo
      end endgenerate
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.top_scope(true)
      end
    ).to match_string(<<~'SCOPE')
      generate if (1) begin : foo
      end endgenerate
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.top_scope(false)
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.parameters parameters
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
        localparam logic BAR = 0;
        localparam logic BAZ = 0;
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.variables variables
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
        logic bar;
        logic baz;
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.loop_size loop_size
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
        genvar i;
        genvar j;
        genvar k;
        for (i = 0;i < 1;++i) begin : g
          for (j = 0;j < 2;++j) begin : g
            for (k = 0;k < 3;++k) begin : g
            end
          end
        end
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.body { 'assign bar = 1;' }
        s.body { |c| c << 'assign baz = 2;' }
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
        assign bar = 1;
        assign baz = 2;
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.body { 'assign bar = 1;' }
        s.body { |c| c << 'assign baz = 2;' }
        s.loop_size loop_size
        s.variables variables
        s.parameters parameters
      end
    ).to match_string(<<~'SCOPE')
      if (1) begin : foo
        genvar i;
        genvar j;
        genvar k;
        for (i = 0;i < 1;++i) begin : g
          for (j = 0;j < 2;++j) begin : g
            for (k = 0;k < 3;++k) begin : g
              localparam logic BAR = 0;
              localparam logic BAZ = 0;
              logic bar;
              logic baz;
              assign bar = 1;
              assign baz = 2;
            end
          end
        end
      end
    SCOPE

    expect(
      local_scope(:foo) do |s|
        s.body { 'assign bar = 1;' }
        s.body { |c| c << 'assign baz = 2;' }
        s.loop_size loop_size
        s.variables variables
        s.parameters parameters
        s.top_scope
      end
    ).to match_string(<<~'SCOPE')
      generate if (1) begin : foo
        genvar i;
        genvar j;
        genvar k;
        for (i = 0;i < 1;++i) begin : g
          for (j = 0;j < 2;++j) begin : g
            for (k = 0;k < 3;++k) begin : g
              localparam logic BAR = 0;
              localparam logic BAZ = 0;
              logic bar;
              logic baz;
              assign bar = 1;
              assign baz = 2;
            end
          end
        end
      end endgenerate
    SCOPE
  end
end
