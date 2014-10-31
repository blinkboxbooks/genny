require "genny/base"
require "uri"

module Genny
  module URI
    # @param [Hash] opts Options for the generator
    # @option opts [String] :host ('example.com') The host of the generated URI
    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      ::URI::HTTP.build(host: opts[:host] || 'example.com', path: "/#{Genny::String.genny}")
    end
  end
end