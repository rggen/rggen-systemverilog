# frozen_string_literal: true

RgGen.define_simple_feature(:register, :sv_rtl_package) do
  sv_rtl_package do
    build do
      localparam :__byte_width, {
        name: "#{full_name}_byte_width",
        data_type: :int, default: register.byte_width
      }
      localparam :__byte_size, {
        name: "#{full_name}_byte_size",
        data_type: :int, default: register.total_byte_size(hierarchical: true)
      }
      define_array_size_localparam
      define_offset_localparams
    end

    private

    def define_array_size_localparam
      return unless array?

      list = array_size_list
      localparam :__array_size, {
        name: "#{full_name}_array_size",
        data_type: :int, array_size: [list.size], default: array(list)
      }
    end

    def define_offset_localparams
      if array?
        define_array_offset_localparams
      else
        define_single_offset_localparam
      end
    end

    def define_array_offset_localparams
      width = register_block.local_address_width
      size_list = array_size_list
      value_list = group_address_list(address_list, size_list).first
      localparam :__offset, {
        name: "#{full_name}_byte_offset",
        data_type: :bit, width: width, array_size: size_list, default: value_list
      }
    end

    def address_list
      register
        .expanded_offset_addresses
        .map { |address| hex(address, register_block.local_address_width) }
    end

    def group_address_list(address_list, size_list)
      list =
        if size_list.size > 1
          group_address_list(address_list, size_list[1..])
        else
          address_list
        end
      list
        .each_slice(size_list.first)
        .map(&method(:array))
    end

    def define_single_offset_localparam
      width = register_block.local_address_width
      value = address_list.first
      localparam :__offset, {
        name: "#{full_name}_byte_offset",
        data_type: :bit, width: width, default: value
      }
    end

    def array?
      register.array?(hierarchical: true)
    end

    def array_size_list
      register.array_size(hierarchical: true)
    end
  end
end
