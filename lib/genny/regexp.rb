require "genny/base"

module Genny
  module Regexp
    DEFAULT_OPTS = {
      min: 2,
      max: 5
    }
    # A bit unecessary, but who knows, maybe someone will have use for it
    def self.genny(_opts = {})
      %r{.*}
    end

    def genny(opts = {})
      raise NotImplementedError, "This regular expression doesn't seem to support the `source` method" unless self.respond_to?(:source)
      begin
        generate_from_regexp_string(self.source, DEFAULT_OPTS.merge(opts))
      rescue
        raise NotImplementedError, "Looks like Genny doesn't support the regular expression #{self.source}. Feel like adding support? https://github.com/blinkboxbooks/genny"
      end
    end

    private

    def generate_from_regexp_string(string, opts = {})
      string.scan(/(?:\[([^\]]+)\]|\((?:\?<[^>]+>|\?:)?([^\)]*)\)|([^\^\$]))(\*\??|\+\??|\{(\d*),?(\d*)\})?/).map do |group|
        ranges, subexpr, char, limit, min, max = group
        if !ranges.nil?
          chars = array_from_ranges(ranges)
          get_char = proc { chars.sample }
        elsif !subexpr.nil?
          get_char = proc { generate_from_regexp_string(subexpr, opts) }
        else
          get_char = proc { char }
        end

        min = max = "1" if limit.nil?
        if min.nil? || min.empty?
          max = (max.nil? || max.empty?) ? opts[:max] : max.to_i
          min = [opts[:min], max].min
        elsif max.empty?
          min = max = min.to_i
        else
          min = min.to_i
          max = max.to_i
        end
        num = max == min ? min : Random.rand(max - min) + min
        
        num.times.inject("") do |str, _|
          str << get_char.call
        end
      end.join
    end

    def array_from_ranges(ranges)
      ranges.scan(/(([^\\])-(.)|.)/).inject([]) do |all, match|
        if match[2].nil?
          all.push(match.first)
        else
          all.push(*(match[1]..match[2]).to_a)
        end
      end
    end
  end
end