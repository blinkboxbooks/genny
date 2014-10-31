require "genny/base"

module Genny
  # This one's a bit useless, but it makes mapping the JsonSchema stuff easier
  module NilClass
    def self.genny(_opts = {})
      nil
    end
  end
end