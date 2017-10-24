require 'rspec'

describe 'Messages test' do
  def to_json(message)
    {
      api_id: message.api_id,
      error_code: message.error_code,
      from_number: message.from_number,
      message_direction: message.message_direction,
      message_state: message.message_state,
      message_time: message.message_time,
      message_type: message.message_type,
      message_uuid: message.message_uuid,
      resource_uri: message.resource_uri,
      to_number: message.to_number,
      total_amount: message.total_amount,
      total_rate: message.total_rate,
      units: message.units
    }.to_json
  end

  def to_json_create(message)
    {
      message: message.message,
      message_uuid: message.message_uuid,
      api_id: message.api_id
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

  it 'fetches details of a message' do
    contents = File.read(Dir.pwd + '/spec/mocks/messageGetResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.messages
                   .get(
                     'SAXXXXXXXXXXXXXXXXXX'
                   )
    expect(JSON.parse(to_json(response)))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Message/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
    expect(response.id).to eql(response.message_uuid)
  end

  it 'lists all messages' do
    contents = File.read(Dir.pwd + '/spec/mocks/messageListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.messages
                                .list(
                                  subaccount: 'SAXXXXXXXXXXXXXXXXX',
                                  offset: 3,
                                  message_direction: 'inbound',
                                  message_state: 'delivered'
                                ))

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj
    end
    contents['objects'] = objects

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Message/',
                     method: 'GET',
                     data: {
                       subaccount: 'SAXXXXXXXXXXXXXXXXX',
                       offset: 3,
                       message_direction: 'inbound',
                       message_state: 'delivered'
                     })
  end

  it 'sends a message' do
    contents = File.read(Dir.pwd + '/spec/mocks/messageSendResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.messages
                                         .create(
                                           '9898989890',
                                           %w[9090909090 9898989898],
                                           'message',
                                           type: 'sms',
                                           url: 'http://url.com',
                                           method: 'POST',
                                           log: true
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Message/',
                     method: 'POST',
                     data: {
                       src: '9898989890',
                       dst: '9090909090<9898989898',
                       text: 'message',
                       type: 'sms',
                       url: 'http://url.com',
                       method: 'POST',
                       log: true
                     })
  end

  it 'src same as dst exception while sending a message' do
    contents = File.read(Dir.pwd + '/spec/mocks/messageSendResponse.json')
    mock(201, JSON.parse(contents))
    expect do
      @api.messages
          .create(
            '9898989898',
            %w[9090909090 9898989898],
            'message',
            type: 'sms',
            url: 'http://url.com',
            method: 'POST',
            log: true
          )
    end
      .to raise_error(
        Plivo::Exceptions::InvalidRequestError,
        'src and dst cannot be same'
      )
  end
end
