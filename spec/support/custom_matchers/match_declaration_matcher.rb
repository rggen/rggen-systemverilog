# frozen_string_literal: true

RSpec::Matchers.define(:match_declaration) do |expected_declaration|
  match do |actual|
    @actual_declaration = actual.declaration
    values_match?(expected_declaration, @actual_declaration.to_s)
  end

  failure_message do
    "expected: #{expected_declaration}\n" \
    "     got: #{@actual_declaration}\n\n"
  end
end
