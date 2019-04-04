# frozen_string_literal: true

require 'spec_helper'

module RgGen::SystemVerilog::Utility
  describe PackageDefinition do
    def package_definition(name, &block)
      PackageDefinition.new(name: name, &block).to_code
    end

    def context
      self
    end

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
        package_definition(:foo_pkg) do
          package_import context.packages[0]
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          import bar_pkg::*;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do
          package_imports context.packages
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          import bar_pkg::*;
          import baz_pkg::*;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do
          include_file context.include_files[0]
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          `include "foo.svh"
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do
          include_files context.include_files
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          `include "foo.svh"
          `include "bar.svh"
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do
          body { 'int foo;' }
          body { |c| c << 'int bar;' }
        end
      ).to match_string(<<~'PACKAGE')
        package foo_pkg;
          int foo;
          int bar;
        endpackage
      PACKAGE

      expect(
        package_definition(:foo_pkg) do
          body { 'int foo;' }
          body { |c| c << 'int bar;' }
          include_files context.include_files
          package_imports context.packages
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
