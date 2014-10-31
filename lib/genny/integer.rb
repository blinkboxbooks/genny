require "genny/base"

module Genny
  module Integer
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      min = opts[:minimum] || 10
      max = opts[:maximum] || 1000
      Random.rand(max - min + 1) + min
    end
  end
end