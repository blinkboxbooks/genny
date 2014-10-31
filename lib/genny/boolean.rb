require "genny/base"

module Genny
  module Boolean
    def self.genny(_opts = {})
      [true, false].sample
    end
  end
end