require "genny/base"

module Genny
  module Date
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      opts[:from] ||= ::Date.new(1970, 1, 1)
      opts[:until] ||= ::Date.today
      ::Date.jd(Random.rand(opts[:until].jd - opts[:from].jd) + opts[:from].jd)
    end
  end
end