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
        str = generate_from_regexp_string(self.source, DEFAULT_OPTS.merge(opts))
        raise unless str.match(self)
      rescue
        raise NotImplementedError, "Looks like Genny doesn't support the regular expression #{self.source}. Feel like adding support? https://github.com/blinkboxbooks/genny"
      end
      str
    end

    private

    def generate_from_regexp_string(string, opts = {})
      string.sub!(/^\^?(.+?)\$?$/, '\1')
      string.scan(/(?:\[([^\]]+)\]|\((?:\?<[^>]+>|\?:)?(.*)\)|\\([*+?\\\{\}\[\]WwDdSs.^$])|([^*+?\{\}\[\]]))(\*\??|\+\??|\{(\d*),?(\d*)\})?/).map do |group|
        ranges, subexpr, special_char, char, limit, min, max = group
        if !ranges.nil?
          chars = array_from_ranges(ranges)
          get_char = proc { chars.sample }
        elsif !subexpr.nil?
          get_char = proc { generate_from_regexp_string(subexpr, opts) }
        elsif !special_char.nil?
          get_char = special_char_parser(special_char)
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

    def special_char_parser(special_char)
      case special_char
      when "w"
        proc { (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + %w{_}).sample }
      when "W"
        proc { ((" ".."/").to_a + ("[".."`").to_a + ("{".."~").to_a - %{_}).sample }
      when "d"
        proc { ("0".."9").to_a.smaple }
      when "D"
        proc { (('a'..'z').to_a + ('A'..'Z').to_a).sample }
      when "s"
        proc { " " }
      when "S"
        proc { (' '..'~').to_a .sample }
      else
        proc { special_char }
      end
    end
  end
end