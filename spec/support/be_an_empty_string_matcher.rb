RSpec::Matchers.define :be_an_empty_string do

  match do |actual|
    actual.is_a?(String) && actual.empty?
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be an empty string"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not be an empty string"
  end

  description do
    "be an empty string"
  end

end
