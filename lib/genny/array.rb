require "genny/base"

module Genny
  module Array
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      opts[:classes] ||= []
      raise ArgumentError, "classes must be an array" unless opts[:classes].respond_to?(:select)
      klasses = [*opts[:classes]].select { |klass| klass.respond_to?(:genny) }
      return [] if klasses.empty?
      min_count = opts[:minItems] || 1
      max_count = opts[:maxItems] || 5
      count = Random.rand(max_count - min_count + 1) + min_count
      return count.times.map do
        klasses.sample.genny(opts[:items] || {})
      end
    end
  end
end