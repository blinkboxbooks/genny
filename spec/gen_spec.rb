require "yaml"
require "json"

context JSONSchema do
  test_schema = YAML.load(open(File.join(__dir__, "example_schema.yaml")))
  test_schema.each_pair do |type, schemas|
    describe "for the #{type} type" do
      schemas.each do |schema|
        it "must work with #{schema.to_json}" do
          exampler = described_class.new(schema)
          generated = exampler.genny
          expect { JSON::Validator.validate!(schema, generated) }.to_not raise_error
        end
      end
    end
  end

  describe "Regexp instances" do
    [
      %r{^[a-z]{10}$},
      %r{^[a-z]{5,6}$},
      %r{^[a-z]{5,}$},
      %r{^[a-z]{,2}$},
      %r{^[a-z]{6,}$},
      %r{^[a-z]{10}$},
      %r{[a-z]+},
      %r{[a-z]+?},
      %r{[a-z]*},
      %r{[a-z]*?},
      %r{[a-z]},
      %r{[a-b]},
      %r{[0-9]{2}},
      %r{a},
      %r{(abc)},
      %r{(abc){1,2}},
      %r{^(?:abc)$},
      %r{^(?<group>abc)$}
    ].each do |re|
      it "must generate a valid string for #{re.source}" do
        generated = re.extend(Genny::Regexp).genny
        expect(generated).to match(re)
      end
    end
  end
end