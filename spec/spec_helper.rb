# frozen_string_literal: true

require 'bundler/setup'
require 'rggen/devtools/spec_helper'
require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.load_features

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/systemverilog'
RgGen::SystemVerilog::RTL.register_component(builder)
RgGen::SystemVerilog::RTL.load_features
