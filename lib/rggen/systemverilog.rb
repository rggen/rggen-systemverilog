# frozen_string_literal: true

require 'docile'
require 'facets/kernel/attr_singleton'

require_relative 'systemverilog/version'

require_relative 'systemverilog/utility/identifier'
require_relative 'systemverilog/utility/data_object'
require_relative 'systemverilog/utility/interface_port'
require_relative 'systemverilog/utility/interface_instance'
require_relative 'systemverilog/utility/structure_definition'
require_relative 'systemverilog/utility/class_definition'
require_relative 'systemverilog/utility/function_definition'
require_relative 'systemverilog/utility/local_scope'
require_relative 'systemverilog/utility/module_definition'
require_relative 'systemverilog/utility/package_definition'
require_relative 'systemverilog/utility/source_file'
require_relative 'systemverilog/utility'

require_relative 'systemverilog/component'
require_relative 'systemverilog/feature'
require_relative 'systemverilog/feature_rtl'
require_relative 'systemverilog/feature_ral'
require_relative 'systemverilog/factories'
