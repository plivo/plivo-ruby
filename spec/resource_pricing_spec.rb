require 'rspec'

describe 'Pricings test' do
  def to_json(pricing)
    {
      api_id: pricing.api_id,
      country: pricing.country,
      country_code: pricing.country_code,
      country_iso: pricing.country_iso,
      message: pricing.message,
      phone_numbers: pricing.phone_numbers,
      voice: pricing.voice
    }.to_json
  end

  it 'get pricing' do
    contents = File.read(Dir.pwd + '/spec/mocks/pricingGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.pricings.get('IN'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Pricing/',
                     method: 'GET',
                     data: {
                       country_iso: 'IN'
                     })
  end
end
