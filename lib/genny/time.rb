require "genny/base"
require "time"

module Genny
  module Time
    def self.genny(_opts = {})
      ::Time.at(Random.rand(::Time.now.to_i)).utc
    end
  end
end