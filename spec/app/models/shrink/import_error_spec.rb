describe Shrink::ImportError do

  it "should be a StandardError" do
    Shrink::ImportError.ancestors.should include(::StandardError)
  end

end
