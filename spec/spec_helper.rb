# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'rggen/core'

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/systemverilog'
