# frozen_string_literal: true

module RgGen
  module SystemVerilog
    class Component < Core::OutputBase::Component
      def declarations(domain, type)
        body = ->(r) { r.declarations(domain, type) }
        [
          @features.each_value.map(&body),
          @children.map(&body)
        ].flatten
      end

      def package_imports(domain)
        body = ->(r) { r.package_imports(domain) }
        [
          @features.each_value.map(&body),
          @children.map(&body)
        ].flatten.uniq
      end
    end
  end
end
