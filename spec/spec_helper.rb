# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.default_setup(builder)

require 'rggen/spreadsheet_loader'
RgGen::SpreadsheetLoader.default_setup(builder)

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/systemverilog/rtl'
RgGen::SystemVerilog::RTL.register_component(builder)
RgGen::SystemVerilog::RTL.load_features

require 'rggen/systemverilog/ral'
RgGen::SystemVerilog::RAL.register_component(builder)
RgGen::SystemVerilog::RAL.load_features

RGGEN_ROOT = ENV['RGGEN_ROOT'] || File.expand_path('../..', __dir__)
RGGEN_SYSTEMVERILOG_ROOT = File.expand_path('..', __dir__)
RGGEN_SAMPLE_DIRECTORY = File.join(RGGEN_ROOT, 'rggen-sample')
