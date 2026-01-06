# frozen_string_literal: true

require File.expand_path('lib/rggen/systemverilog/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-systemverilog'
  spec.version = RgGen::SystemVerilog::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-systemverilog-#{RgGen::SystemVerilog::VERSION}"
  spec.description = <<~DESCRIPTION
    SystemVerilog RTL and UVM RAL model generators for RgGen.
  DESCRIPTION
  spec.homepage = 'https://github.com/rggen/rggen-systemverilog'
  spec.license = 'MIT'

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/rggen/rggen/issues',
    'mailing_list_uri' => 'https://groups.google.com/d/forum/rggen',
    'rubygems_mfa_required' => 'true',
    'source_code_uri' => 'https://github.com/rggen/rggen-systemverilog',
    'wiki_uri' => 'https://github.com/rggen/rggen/wiki'
  }

  spec.files = `git ls-files lib LICENSE CODE_OF_CONDUCT.md README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.2')
end
