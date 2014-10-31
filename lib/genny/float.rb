require "genny/base"

module Genny
  module Float
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      min = opts[:minimum] || 10
      max = opts[:maximum] || 1000
      # TODO: exclusive minimum/maximum
      Random.rand * (max - min) + min
    end
  end
end