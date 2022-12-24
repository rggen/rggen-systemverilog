# frozen_string_literal: true

RgGen.define_simple_feature(:bit_field, :sv_rtl_package) do
  sv_rtl_package do
    build do
      localparam :__width, {
        name: "#{full_name}_bit_width",
        data_type: :int, default: bit_field.width
      }
      localparam :__mask, {
        name: "#{full_name}_bit_mask",
        data_type: :bit, width: bit_field.width, default: mask_value
      }
      define_offset_localparam
      define_label_localparams
    end

    private

    def mask_value
      hex((1 << bit_field.width) - 1, bit_field.width)
    end

    def define_offset_localparam
      if bit_field.sequential?
        define_sequential_offset_localparam
      else
        define_single_offset_localparam
      end
    end

    def define_sequential_offset_localparam
      size = bit_field.sequence_size
      localparam :__offset, {
        name: "#{full_name}_bit_offset",
        data_type: :int, array_size: [size], default: offset_value(size)
      }
    end

    def offset_value(size)
      array(Array.new(size, &bit_field.method(:lsb)))
    end

    def define_single_offset_localparam
      localparam :__offset, {
        name: "#{full_name}_bit_offset",
        data_type: :int, default: bit_field.lsb
      }
    end

    def define_label_localparams
      bit_field.labels
        .each { |label| define_label_localparam(label) }
    end

    def define_label_localparam(label)
      identifier = "label_#{label.name}".downcase.to_sym
      value = hex(label.value, bit_field.width)
      localparam identifier, {
        name: "#{full_name}_#{label.name}",
        data_type: :bit, width: bit_field.width, default: value
      }
    end
  end
end
