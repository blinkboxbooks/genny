require "genny/base"

module Genny
  module Regexp
    # A bit unecessary, but who knows, maybe someone will have use for it
    def self.genny(_opts = {})
      %r{.*}
    end

    def genny(opts = {})
      raise NotImplementedError, "I gotta get some sleep. Genny can't make strings which fit Regexps... yet."
    end
  end
end