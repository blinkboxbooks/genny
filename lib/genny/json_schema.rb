require "genny/base"
require "delegate"

class JSONSchema < SimpleDelegator
  VALIDATE = begin
    require "json-schema"
    true
  rescue LoadError
    false
  end

  def initialize(hash, validate: VALIDATE, definitions: {})
    # TODO: ensure it's a valid schema if VALIDATE
    hash['definitions'] = (definitions || {}).merge(hash['definitions'] || {})
    super(hash)
  end

  def genny(additional_opts = {})
    opts = Genny.symbolize(self.merge(additional_opts))
    return opts[:enum].sample if opts.has_key?(:enum)
    return schema_from_ref(opts[:'$ref']).genny if opts[:'$ref']

    klass = {
      "array" => Genny::Array,
      "boolean" => Genny::Boolean,
      "number" => Genny::Float,
      "object" => Genny::Hash,
      "integer" => Genny::Integer,
      "null" => Genny::NilClass,
      "string" => Genny::String,
      nil => Genny::Hash
    }[opts[:type]]
    raise "Cannot generate JSON Schema object of type '#{opts[:type]}'." unless klass.respond_to?(:genny)
    # Convert the JSONSchema items object into something Array.genny can cope with
    opts[:items] = (opts[:items].is_a?(::Array) ? opts[:items] : [opts[:items]].compact).map do |item|
      JSONSchema.new(item, definitions: opts[:definitions])
    end if klass == Genny::Array
    klass.genny(opts)
  end

  private

  # Deals with JSON-Schema valid "#/definitions/xyz" style references and Swagger style "Thing" style.
  def schema_from_ref(name)
    if self['definitions'][name]
      subschema = self['definitions'][name]
    elsif name.match(%r{^#/(.+)$})
      subschema = self.dup
      Regexp.last_match[1].split("/").each { |key| subschema = subschema[key] }
    end

    return JSONSchema.new(
      subschema,
      definitions: self['definitions'],
      validate: false
    ) if subschema
    raise "Unknown definition"
  rescue
    raise "Cannot find definition #{name}"
  end
end

module Genny
  module Hash
    @@additional_properties = 1

    def self.additional_properties=(chance)
      raise ArgumentError, "chance must be a probability between 0 and 1" if chance < 0 || chance > 1
      @@additional_properties = chance
    end

    def self.genny(opts = {})
      opts = Genny.symbolize(opts)
      opts[:additional_properties_n] ||= 3
      raise "additional_properties_n must be an integer" unless opts[:additional_properties_n] >= 0
      opts[:properties] ||= {}
      if opts[:additionalProperties].is_a?(::Hash)
        (opts[:additional_properties_n] * @@additional_properties).round.times do |i|
          opts[:properties]["gennyAdditionalProperty#{i + 1}"] ||= opts[:additionalProperties]
        end
      end
      ::Hash[opts[:properties].map { |key, schema_object|
        next nil if !(opts[:required] || []).include?(key) && Random.rand > @@additional_properties
        [
          key,
          JSONSchema.new(
            schema_object.merge(
              hint: [key, opts[:hint]].compact.join(" ")
            ),
            definitions: opts[:definitions],
            validate: false
          ).genny
        ]
      }.compact]
    end
  end
end