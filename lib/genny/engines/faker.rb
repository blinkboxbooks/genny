begin
  require "faker"

  module Genny::String
    # First name
    hint do |opts|
      hint = opts[:hint].downcase
      next unless hint.match("first") && hint.match("name")
      # TODO: ensure the length limits are met
      Faker::Name.first_name
    end

    # Last name
    hint do |opts|
      hint = opts[:hint].downcase
      next unless hint.match("last") && hint.match("name")
      # TODO: ensure the length limits are met
      Faker::Name.last_name
    end

    # Full name
    hint do |opts|
      next unless opts[:hint].downcase.match("name")
      # TODO: ensure the length limits are met
      Faker::Name.name
    end

    # Email address
    hint do |opts|
      next unless opts[:hint].downcase.match("email")
      Faker::Internet.safe_email
    end
  end
rescue LoadError
end