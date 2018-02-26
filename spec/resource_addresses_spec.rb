require 'rspec'

describe 'Addresses test' do
  def to_json(address)
    {
      account: address.account,
      address_line1: address.address_line1,
      address_line2: address.address_line2,
      alias: address.alias,
      api_id: address.api_id,
      city: address.city,
      country_iso: address.country_iso,
      document_details: address.document_details,
      first_name: address.first_name,
      id: address.id,
      last_name: address.last_name,
      postal_code: address.postal_code,
      region: address.region,
      salutation: address.salutation,
      subaccount: address.subaccount,
      url: address.url,
      validation_status: address.validation_status,
      verification_status: address.verification_status
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_update(address)
    {
        api_id: address.api_id,
        message: address.message
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_create(address)
    {
        api_id: address.api_id,
        message: address.message
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_list(list_object)
    objects_json = list_object[:objects].map do |object|
      obj = JSON.parse(to_json(object))
      obj.delete('api_id')
      obj.reject { |_, v| v.nil? }
    end
    {
        api_id: list_object[:api_id],
        meta: list_object[:meta],
        objects: objects_json
    }.to_json
  end

  it 'creates an address' do
    contents = File.read(Dir.pwd + '/spec/mocks/addressCreateResponse.json')
    mock(200, JSON.parse(contents))

    expect(JSON.parse(to_json_create(@api.addresses
                                         .create(
                                             'US',
                                             'Mr',
                                             'Bruce',
                                             'Wayne',
                                             '1234',
                                             'Wayne Towers',
                                             'New York',
                                             'NY',
                                             '12345',
                                             'others',
                                             nil,
                                             {
                                               callback_url: 'https://callback.url',
                                               auto_correct_address: true
                                             }
                                         ))))
        .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verification/Address/',
                     method: 'POST',
                     data: {
                         country_iso: 'US',
                         salutation: 'Mr',
                         first_name: 'Bruce',
                         last_name: 'Wayne',
                         address_line1: '1234',
                         address_line2: 'Wayne Towers',
                         city: 'New York',
                         region: 'NY',
                         postal_code: '12345',
                         address_proof_type: 'others',
                         callback_url: 'https://callback.url',
                         auto_correct_address: true
                     })
  end

  it 'fetches details of an address' do
    contents = File.read(Dir.pwd + '/spec/mocks/addressGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.addresses.get('12345'))))
        .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verification/Address/'\
                     '12345/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all addresses' do
    contents = File.read(Dir.pwd + '/spec/mocks/addressListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.addresses.list({verification_status: 'pending'}))

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj.reject { |_, v| v.nil? }
    end
    contents['objects'] = objects

    expect(JSON.parse(response).reject { |_, v| v.nil? })
        .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verification/Address/',
                     method: 'GET',
                     data: {verification_status: 'pending'})
  end

  it 'updates the address' do
    id = '12345'
    contents = File.read(Dir.pwd + '/spec/mocks/addressUpdateResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.addresses
                                         .update(id, nil, {
                                           salutation: 'Mr',
                                           first_name: 'Bruce'
                                         }))))
        .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verification/Address/' + id + '/',
                     method: 'POST',
                     data: {
                         salutation: 'Mr',
                         first_name: 'Bruce'
                     })
  end

  it 'deletes the address' do
    id = '12345'
    contents = '{}'
    mock(204, JSON.parse(contents).reject { |_, v| v.nil? })
    @api.addresses.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verification/Address/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
