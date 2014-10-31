require "genny/base"

module Genny
  module Array
    # Generates an array of items of the types specified.
    #
    # @example No classes specified, can only return an empty array
    #     Genny::Array.genny
    #     # => []
    #
    # @example Specifying classes
    #     Genny::Array.genny(items: [Genny::Integer, JSONSchema.new("type" => "string", "format" => "ipv4")])
    #     # => ["mcztjgoriq", "nohfcavjyz", 739]
    #
    # @param [Hash] opts Options for the generator
    # @option opts [Array<#genny>,#genny] :items The items which should be used to populate the array
    # @option opts [Integer] :minItems (1) The fewest number of items the array should have
    # @option opts [Integer] :maxItems (5) The largest number of items the array should have
    # @raise RuntimeError if no :items given and minItems > 0
    # @raise RuntimeError if :maxItems is lower than :minItems
    # @return [Array]
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      opts[:items] = opts[:items].is_a?(Array) ? opts[:items] : [opts[:items]].compact
      raise ArgumentError, "classes must be an array" unless opts[:items].respond_to?(:select)
      items = opts[:items].select { |item| item.respond_to?(:genny) }
      if items.empty?
        raise "No items given, cannot populate the array." unless opts[:minItems].to_i == 0
        return []
      end
      min_count = opts[:minItems] || 1
      max_count = opts[:maxItems] || [opts[:minItems], 5].max
      raise "maxItems is lower than minItems" if max_count < min_count
      count = Random.rand(max_count - min_count + 1) + min_count
      return count.times.map { items.sample.genny }
    end
  end
end