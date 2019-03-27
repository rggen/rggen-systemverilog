# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rggen/systemverilog/version'

Gem::Specification.new do |spec|
  spec.name = 'rggen-systemverilog'
  spec.version = RgGen::SystemVerilog::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['taichi730@gmail.com']

  spec.summary = "rggen-systemverilog-#{RgGen::SystemVerilog::VERSION}"
  spec.description = 'RgGen output components for SystemVerilog RTL and RAL.'
  spec.homepage = 'https://github.com/rggen/rggen-systemverilog'
  spec.license = 'MIT'

  spec.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_runtime_dependency 'docile', '>= 1.1.5'
  spec.add_runtime_dependency 'facets', '>= 3.0'

  spec.add_development_dependency 'bundler'
end
