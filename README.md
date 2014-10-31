# Genny

Genny likes making things up. Unlike other faker libraries this one is based around generating whole data structures using JSONSchema as a basis.

This gem can be used without any additional gems. The following gems will be used if they can be loaded, but not having them installed/in your bundle will reduce functionality rather than prevent the library from working:

- [json-schema](https://rubygems.org/gems/json-schema) - for JSONSchema validation
- [faker](https://rubygems.org/gems/faker) - for better hinted strings

## Examples

### Extending core classes

Extending the core classes to have the `genny` class method is handy, but may not be desired. If you wish to use this style then you must initialise it:

```
Genny::String.genny
# =>  "pymliestqk" 
String.respond_to?(:genny)
# => false

Genny.extend_core
# => [NilClass, URI, Time, Date, Array, Float, String, Regexp, Integer, Hash]

String.respond_to?(:genny)
# => true
String.genny
# => "oniqpsxubm"
```

### Strings

```
Genny::String.genny
# => "fusmtzavyi"
Genny::String.genny(format: "ipv4")
# => "171.199.220.179"

# You can define your own formats
Genny::String.format("tla") do |opts|
  3.times.map { ('A'..'Z').to_a.sample }.join
end
Genny::String.genny(format: "tla")
# => "XSE"
```

### Objects

```
# Genny makes JSONSchema a first class... class. It acts like a hash but has a genny instance method.
# If the json-schema gem can be loaded then the new method will raise an error if it's an invalid schema.
js = JSONSchema.new(
  "type" => "object",
  "properties" => {
    "key" => {
      "type" => "string"
    }
  }
)
# => {"type"=>"object", "properties"=>{"key"=>{"type"=>"string"}}, "definitions"=>{}}
js.genny
# => {"key"=>"gcqhsanwzd"}
```

### Arrays

A generated array will always be empty unless a `:classes` option has been defined. Any class in that array that responds to `genny` may be picked as the prototype for an element of the generated array.

```
Genny::Array.genny
# => []

Genny::Array.genny(classes: [Genny::String, Genny::Integer])
# => ["mcztjgoriq", "nohfcavjyz", 739]
```

#### Hinting

```
# Hinting for strings allows you to try and indicate what kind of string you'd like back.
Genny::String.genny(hint: "first name")
# => "Dean"
Genny::String.genny(hint: "name")
# => "Garrison O'Kon"

# And when an object value type is a string, the key will be used as a hint
JSONSchema.new(
  "type" => "object",
  "properties" => {
    "name" => {
      "type" => "string"
    }
  }
).genny
# => { "name" => "Everett Schmitt" }

# You can define your own hinters. Hints defined earlier will take precidence
Genny::String.hint do |opts|
  next unless opts[:hint].include?("answer")
  "42"
end
Genny::String.genny(hint: "the answer")
# => "42"
```

### Numbers

```
Genny::Integer.genny
# => 5
Genny::Integer.genny(maximum: 100)
# => 88
Genny::Integer.genny(minimum: 90, maximum: 100)
# => 92

Genny::Float.genny
# => 234.2934215006394
Genny::Float.genny(minimum: 90, maximum: 100)
# => 96.6691946757789 
```

### Dates & Times

```
Genny::Date.genny
# => #<Date: 1987-03-01 ((2446856j,0s,0n),+0s,2299161j)> 
Genny::Time.genny
# => 1988-11-23 05:48:04 UTC 

# These are also a format of string (for JSONSchema purposes)
Genny::String.genny(format: "date")
# => "1975-07-24"
Genny::String.genny(format: "date-time")
# => "1994-10-11T07:32:55Z"
```

### Boolean

There being no core `Boolean` class this must be called directly even if the core classes have been extended.

```
Genny::Boolean.genny
# => false
Genny::Boolean.genny
# => true
```

### URIs

```
Genny::URI.genny
# => #<URI::HTTP:0x007f8c1c164f90 URL:http://example.com/erichqlvjx>

# URIs are also a format of string (for JSONSchema purposes)
Genny::String.genny(format: "uri")
# => "http://example.com/itgxsewckm"
```

### Regular expressions

Generating a regular expression is a bit useless (it always returns `/.*/` which matches most strings) but there is also an instance `genny` method defined which will, when I implement it, make a best effort at creating a string which matches the given regular expression.

```
Genny::Regexp.genny
# => /.*/

# The following hasn't been implemented yet. But soon!
/[a-f0-9]{2}/.extend(Genny::Regexp).genny
# => "a7"
Genny.extend_core
/[a-f0-9]{2}/.genny
# => "5c"
```

## Contributing

Yes please! Pull requests would be lovely.

## Contact

I am [@jphastings](https://twitter.com/jphastings) and I work at [blinkbox Books](https://github.com/blinkboxbooks), do get in touch.