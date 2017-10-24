require 'rspec'

describe 'Applications test' do
  def to_json(application)
    {
      answer_method: application.answer_method,
      answer_url: application.answer_url,
      app_id: application.app_id,
      api_id: application.api_id,
      app_name: application.app_name,
      default_app: application.default_app,
      default_endpoint_app: application.default_endpoint_app,
      enabled: application.enabled,
      fallback_answer_url: application.fallback_answer_url,
      fallback_method: application.fallback_method,
      hangup_method: application.hangup_method,
      hangup_url: application.hangup_url,
      message_method: application.message_method,
      message_url: application.message_url,
      public_uri: application.public_uri,
      resource_uri: application.resource_uri,
      sip_uri: application.sip_uri,
      sub_account: application.sub_account
    }.to_json
  end

  def to_json_update(application)
    {
      api_id: application.api_id,
      message: application.message
    }.to_json
  end

  def to_json_create(application)
    {
      message: application.message,
      app_id: application.app_id,
      api_id: application.api_id
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

  it 'creates a application' do
    contents = File.read(Dir.pwd + '/spec/mocks/applicationCreateResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.applications
                                         .create(
                                           'name',
                                           answer_method: 'POST',
                                           default_number_app: true
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Application/',
                     method: 'POST',
                     data: {
                       app_name: 'name',
                       answer_method: 'POST',
                       default_number_app: true
                     })
  end

  it 'fetches details of an application' do
    contents = File.read(Dir.pwd + '/spec/mocks/applicationGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.applications.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Application/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all applications' do
    contents = File.read(Dir.pwd + '/spec/mocks/applicationListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.applications
                                .list(
                                  subaccount: 'SAXXXXXXXXXXXXXXXXX',
                                  offset: 4
                                ))

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj
    end
    contents['objects'] = objects

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Application/',
                     method: 'GET',
                     data: {
                       subaccount: 'SAXXXXXXXXXXXXXXXXX',
                       offset: 4
                     })
  end

  it 'updates the application' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/applicationModifyResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.applications
                                         .update(
                                           id,
                                           answer_url: 'http://answer.url',
                                           answer_method: 'POST',
                                           default_number_app: true
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Application/' + id + '/',
                     method: 'POST',
                     data: {
                       answer_url: 'http://answer.url',
                       answer_method: 'POST',
                       default_number_app: true
                     })
  end

  it 'deletes the application' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.applications.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Application/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
