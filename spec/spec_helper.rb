# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/basic_output_components'
