require "genny/base"
require "uri"

module Genny
  module URI
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      ::URI::HTTP.build(host: opts[:host] || 'example.com', path: "/#{Genny::String.genny}")
    end
  end
end