# frozen_string_literal: true

module RgGen
  module BasicOutputComponents
    module SystemVerilog
      class Component < Core::OutputBase::Component
        def declarations(domain, type)
          body = ->(r) { r.declarations(domain, type) }
          [
            @features.each_value.map(&body),
            @children.map(&body)
          ].flatten
        end
      end
    end
  end
end
