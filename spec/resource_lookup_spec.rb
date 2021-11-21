require "rspec"
require "json"
require "spec_helper"

describe "Lookup test" do
  it "lookup a number" do
    contents = File.read(Dir.pwd + "/spec/mocks/lookupGetResponse.json")
    mock(200, JSON.parse(contents))
    response = @api.lookup
                   .get(
                     "+14154305555",
                     "carrier"
                   )
    expect(response.phone_number).to eql("+14154305555")
  end
end
