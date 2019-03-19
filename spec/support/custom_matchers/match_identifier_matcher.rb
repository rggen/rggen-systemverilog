# frozen_string_literal: true

RSpec::Matchers.define(:match_identifier) do |expected_identifier|
  match do |actual|
    @actual_identifier =
      if actual.respond_to?(:identifier)
        actual.identifier
      else
        actual
      end
    values_match?(expected_identifier, @actual_identifier.to_s)
  end

  failure_message do
    "expected: #{expected_identifier}\n" \
    "     got: #{@actual_identifier}\n\n"
  end
end
