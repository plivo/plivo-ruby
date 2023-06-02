require 'rspec'

describe 'Numbers test' do
  def to_json(number)
    {
      api_id: number.api_id,
      added_on: number.added_on,
      alias: number.alias,
      application: number.application,
      carrier: number.carrier,
      monthly_rental_rate: number.monthly_rental_rate,
      number: number.number,
      number_type: number.number_type,
      region: number.region,
      resource_uri: number.resource_uri,
      sms_enabled: number.sms_enabled,
      sms_rate: number.sms_rate,
      sub_account: number.sub_account,
      voice_enabled: number.voice_enabled,
      voice_rate: number.voice_rate,
      tendlc_campaign_id: number.tendlc_campaign_id,
      tendlc_registration_status: number.tendlc_registration_status,
      toll_free_sms_verification: number.toll_free_sms_verification,
      renewal_date: number.renewal_date,
      cnam_lookup: number.cnam_lookup
    }.to_json
  end

  def to_json_update(number)
    {
      api_id: number.api_id,
      message: number.message
    }.to_json
  end

  def to_json_create(number)
    {
      message: number.message,
      app_id: number.app_id,
      api_id: number.api_id
    }.to_json
  end

  def to_json_list(list_object)
    objects_json = list_object[:objects].map do |object|
      obj = JSON.parse(to_json(object))
      obj.delete('api_id')
      obj
    end
    {
      api_id: list_object[:api_id],
      meta: list_object[:meta],
      objects: objects_json
    }.to_json
  end

  it 'fetches details of a rented number' do
    contents = File.read(Dir.pwd + '/spec/mocks/numberGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.numbers.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Number/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all rented numbers' do
    contents = File.read(Dir.pwd + '/spec/mocks/numberListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.numbers
                                .list(
                                  number_startswith: '123',
                                  services: 'voice,sms',
                                  type: 'local',
                                  offset: 3
                                ))

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj
    end
    contents['objects'] = objects

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Number/',
                     method: 'GET',
                     data: {
                       number_startswith: '123',
                       services: 'voice,sms',
                       type: 'local',
                       offset: 3
                     })
  end

  it 'add a number from carrier' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/numberCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.numbers
                                         .add_number(
                                           ['909090909090',
                                            909_090_909_091],
                                           'carrier',
                                           'region',
                                           app_id: 'app id',
                                           subaccount: 'SAXXXXXXXXXXXXXXXXXX'
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Number/',
                     method: 'POST',
                     data: {
                       numbers: '909090909090,909090909091',
                       carrier: 'carrier',
                       region: 'region',
                       app_id: 'app id',
                       subaccount: 'SAXXXXXXXXXXXXXXXXXX'
                     })
  end

  it 'updates the number' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/numberUpdateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.numbers
                                         .update(id,
                                                 subaccount: 'SAXXXXXXXXXXXXXXXXXX',
                                                 alias: 'alias'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Number/' + id + '/',
                     method: 'POST',
                     data: {
                       subaccount: 'SAXXXXXXXXXXXXXXXXXX',
                       alias: 'alias'
                     })
  end

  it 'deletes the number' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.numbers.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Number/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
