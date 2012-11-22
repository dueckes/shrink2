RSpec::Matchers.define :be_an_empty_array do

  match do |actual|
    actual.is_a?(Array) && actual.empty?
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be an empty array"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not be an empty array"
  end

  description do
    "be an empty array"
  end

end
