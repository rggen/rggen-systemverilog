# frozen_string_literal: true

module RgGen
  module SystemVerilog
    module Common
      class Component < Core::OutputBase::Component
        def declarations
          @declarations ||= Hash.new { |h, k| h[k] = [] }
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
end
