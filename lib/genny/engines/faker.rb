begin
  require "faker"

  # First name
  Genny::String.hint do |opts|
    hint = opts[:hint].downcase
    next unless hint.match("first") && hint.match("name")
    # TODO: ensure the length limits are met
    Faker::Name.first_name
  end

  # Last name
  Genny::String.hint do |opts|
    hint = opts[:hint].downcase
    next unless hint.match("last") && hint.match("name")
    # TODO: ensure the length limits are met
    Faker::Name.last_name
  end

  # Full name
  Genny::String.hint do |opts|
    next unless opts[:hint].downcase.match("name")
    # TODO: ensure the length limits are met
    Faker::Name.name
  end

  # Email address
  Genny::String.hint do |opts|
    next unless opts[:hint].downcase.match("email")
    Faker::Internet.safe_email
  end

  # Email address as format
  Genny::String.format("email") do |opts|
    Faker::Internet.safe_email
  end
rescue LoadError
end