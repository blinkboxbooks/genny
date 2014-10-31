$LOAD_PATH.unshift File.join(__dir__, "../lib")
require "genny"

module Helpers
  
end

RSpec.configure do |c|
  c.include Helpers
end