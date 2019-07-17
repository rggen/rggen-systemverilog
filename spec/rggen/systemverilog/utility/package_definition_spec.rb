# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe PackageDefinition do
    include RgGen::SystemVerilog::Utility

    let(:packages) do
      [:bar_pkg, :baz_pkg]
    end

    let(:include_files) do
      ['foo.svh', 'bar.svh']
    end

    it 'パッケージ定義を行うコードを返す' do
      expect(
        package_definition(:foo_pkg)
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.package_import packages[0]
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          import bar_pkg::*;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.package_imports packages
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          import bar_pkg::*;
          import baz_pkg::*;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.include_file include_files[0]
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          `include "foo.svh"
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.include_files include_files
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          `include "foo.svh"
          `include "bar.svh"
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.body { 'int foo;' }
          p.body { |c| c << 'int bar;' }
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          int foo;
          int bar;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do |p|
          p.body { 'int foo;' }
          p.body { |c| c << 'int bar;' }
          p.include_files include_files
          p.package_imports packages
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          import bar_pkg::*;
          import baz_pkg::*;
          `include "foo.svh"
          `include "bar.svh"
          int foo;
          int bar;
        endpackage
      PACKAGE
    end
  end
end
