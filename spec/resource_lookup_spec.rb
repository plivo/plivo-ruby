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
    expect(JSON.parse(to_json(response))).to eql(JSON.parse(contents))
    compare_requests(uri: "/v1/Lookup/Number/+14154305555",
                     method: "GET",
                     data: nil)
    expect(response.phone_number).to eql("+14154305555")
  end
end
