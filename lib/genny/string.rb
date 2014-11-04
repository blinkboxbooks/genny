require "genny/base"

module Genny
  module String
    @@formats = {}
    @@hints = []

    def self.format(format, &block)
      @@formats[format] = block
    end

    def self.hint(&block)
      @@hints.push(block)
    end

    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      viable_formats = @@formats.keys & [*opts[:format]]
      return @@formats[viable_formats.sample].call(opts) unless viable_formats.empty?
      if (re = ::Regexp.new(opts[:format]) rescue false)
        begin
          return re.extend(Genny::Regexp).genny
        rescue
        end
      end
      guess = @@hints.inject(nil) { |guess, hint|
        break guess if !(guess = hint.call(opts)).nil?
      } if opts[:hint]
      return guess unless guess.nil?
      opts[:minLength] ||= 10
      opts[:maxLength] ||= 10
      length = Random.rand(opts[:maxLength] - opts[:minLength] + 1) + opts[:minLength]
      ('a'..'z').to_a.sample(length).join
    end

    format("date-time") { |opts| Genny::Time.genny(opts).iso8601 }
    format("date")      { |opts| Genny::Date.genny(opts).iso8601 }
    format("ipv4")      { |opts| 4.times.map { Random.rand(255) }.join(".") }
    format("ipv6")      { |opts| 8.times.map { Random.rand(65536).to_s(16).rjust(4, "0") }.join(":") }
    format("uri")       { |opts| Genny::URI.genny(opts).to_s }
    format("email")     { |opts| Genny::String.genny + "@example.com" }
  end
end