require 'rspec'

describe 'Endpoints test' do
  def to_json(endpoint)
    {
      alias: endpoint.alias,
      application: endpoint.application,
      endpoint_id: endpoint.endpoint_id,
      resource_uri: endpoint.resource_uri,
      sip_contact: endpoint.sip_contact,
      sip_expires: endpoint.sip_expires,
      sip_registered: endpoint.sip_registered,
      sip_uri: endpoint.sip_uri,
      sip_user_agent: endpoint.sip_user_agent,
      sub_account: endpoint.sub_account,
      username: endpoint.username,
      password: endpoint.password
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_update(endpoint)
    {
      api_id: endpoint.api_id,
      message: endpoint.message
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_create(endpoint)
    {
      username: endpoint.username,
      alias: endpoint.alias,
      message: endpoint.message,
      endpoint_id: endpoint.endpoint_id,
      api_id: endpoint.api_id
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

  it 'creates a endpoint' do
    contents = File.read(Dir.pwd + '/spec/mocks/endpointCreateResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.endpoints
                                         .create('test_name',
                                                 'pass',
                                                 'nananana'))))
      .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Endpoint/',
                     method: 'POST',
                     data: {
                       username: 'test_name',
                       password: 'pass',
                       alias: 'nananana'
                     })
  end

  it 'fetches details of a endpoint' do
    contents = File.read(Dir.pwd + '/spec/mocks/endpointGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.endpoints.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Endpoint/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all endpoints' do
    contents = File.read(Dir.pwd + '/spec/mocks/endpointListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.endpoints.list)

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj.reject { |_, v| v.nil? }
    end
    contents['objects'] = objects

    expect(JSON.parse(response).reject { |_, v| v.nil? })
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Endpoint/',
                     method: 'GET',
                     data: nil)
  end

  it 'updates the endpoint' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/endpointUpdateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.endpoints
                                         .update(id,
                                                 password: 'test pass',
                                                 alias: 'alias'))))
      .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Endpoint/' + id + '/',
                     method: 'POST',
                     data: {
                       password: 'test pass',
                       alias: 'alias'
                     })
  end

  it 'deletes the endpoint' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents).reject { |_, v| v.nil? })
    @api.endpoints.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Endpoint/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
