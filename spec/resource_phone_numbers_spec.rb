require 'rspec'

describe 'Phone Numbers test' do
  def to_json(phone_number)
    {
      country: phone_number.country,
      lata: phone_number.lata,
      monthly_rental_rate: phone_number.monthly_rental_rate,
      number: phone_number.number,
      type: phone_number.type,
      prefix: phone_number.prefix,
      rate_center: phone_number.rate_center,
      region: phone_number.region,
      resource_uri: phone_number.resource_uri,
      restriction: phone_number.restriction,
      restriction_text: phone_number.restriction_text,
      setup_rate: phone_number.setup_rate,
      sms_enabled: phone_number.sms_enabled,
      sms_rate: phone_number.sms_rate,
      voice_enabled: phone_number.voice_enabled,
      voice_rate: phone_number.voice_rate
    }.to_json
  end

  def to_json_buy(phone_number)
    {
      message: phone_number.message,
      status: phone_number.status,
      api_id: phone_number.api_id,
      numbers: phone_number.numbers
    }.to_json
  end

  def to_json_list(list_object)
    objects_json = list_object[:objects].map do |object|
      JSON.parse(to_json(object))
    end
    {
      api_id: list_object[:api_id],
      meta: list_object[:meta],
      objects: objects_json
    }.to_json
  end

  it 'lists all phone_numbers' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.phone_numbers
                                .search(
                                  'IN',
                                  type: 'local',
                                  offset: 4
                                ))

    contents = JSON.parse(contents)

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/',
                     method: 'GET',
                     data: {
                       country_iso: 'IN',
                       type: 'local',
                       offset: 4
                     })
  end

  it 'buy phone number' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_buy(@api.phone_numbers
                                      .buy('909090909090', 'app id'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/909090909090/',
                     method: 'POST',
                     data: {
                       app_id: 'app id'
                     })
  end
end
