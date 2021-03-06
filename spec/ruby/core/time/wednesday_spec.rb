require_relative '../../spec_helper'

describe "Time#wednesday?" do
  it "returns true if time represents Wednesday" do
    Time.local(2000, 1, 5).should.wednesday?
  end

  it "returns false if time doesn't represent Wednesday" do
    Time.local(2000, 1, 1).should_not.wednesday?
  end
end
