require 'rspec'

describe 'Calls test' do
  def to_json(call)
    {
      answer_time: call.answer_time,
      api_id: call.api_id,
      bill_duration: call.bill_duration,
      billed_duration: call.billed_duration,
      call_direction: call.call_direction,
      call_duration: call.call_duration,
      call_uuid: call.call_uuid,
      end_time: call.end_time,
      from_number: call.from_number,
      initiation_time: call.initiation_time,
      parent_call_uuid: call.parent_call_uuid,
      resource_uri: call.resource_uri,
      to_number: call.to_number,
      total_amount: call.total_amount,
      total_rate: call.total_rate,
      stir_verification: call.stir_verification,
      stir_attestation:call.stir_attestation,
      source_ip:call.source_ip,
      cnam_lookup:call.cnam_lookup
    }.to_json
  end

  def to_json_live(call)
    {
      direction: call.direction,
      from: call.from,
      call_status: call.call_status,
      api_id: call.api_id,
      to: call.to,
      caller_name: call.caller_name,
      call_uuid: call.call_uuid,
      request_uuid: call.request_uuid,
      session_start: call.session_start,
      stir_verification: call.stir_verification,
      stir_attestation: call.stir_attestation
    }.to_json
  end

  def to_json_update(call)
    {
      api_id: call.api_id,
      message: call.message
    }.to_json
  end

  def to_json_create(call)
    {
      api_id: call.api_id,
      request_uuid: call.request_uuid,
      message: call.message
    }.to_json
  end

  def to_json_record(recording)
    {
      api_id: recording.api_id,
      message: recording.message,
      recording_id: recording.recording_id,
      url: recording.url
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

  def to_json_list_live(list_object)
    {
      api_id: list_object[:api_id],
      calls: list_object[:calls]
    }.to_json
  end

  it 'creates a call' do
    contents = File.read(Dir.pwd + '/spec/mocks/callCreateResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.calls
                                         .create('+919090909090',
                                                 ['+919898989898'],
                                                 'http://www.answer.url',
                                                 {answer_method: 'POST',
                                                 ring_url: 'http://www.ring.url',
                                                 ring_method: 'POST'}))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/',
                     method: 'POST',
                     data: {
                       from: '+919090909090',
                       to: '+919898989898',
                       answer_url: 'http://www.answer.url',
                       answer_method: 'POST',
                       ring_url: 'http://www.ring.url',
                       ring_method: 'POST'
                     })
  end

  it 'fetches details of a call' do
    contents = File.read(Dir.pwd + '/spec/mocks/callGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.calls.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'fetches details of a live call' do
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_live(@api.calls.get_live('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: { status: 'live' })
  end

  it 'lists all calls' do
    contents = File.read(Dir.pwd + '/spec/mocks/callListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.calls
                                .list(
                                  call_direction: 'inbound',
                                  offset: 3,
                                  bill_duration: '123'
                                ))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/',
                     method: 'GET',
                     data: {
                       call_direction: 'inbound',
                       bill_duration: '123',
                       offset: 3
                     })
  end

  it 'lists all live calls' do
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallListGetResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list_live(@api.calls
                                .list_live)
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/',
                     method: 'GET',
                     data: { status: 'live' })
  end

  it 'transfers the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/callUpdateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.calls
                                     .update(id,
                                             legs: 'both',
                                             aleg_url: 'http://www.aleg.url',
                                             aleg_method: 'POST',
                                             bleg_url: 'http://www.bleg.url',
                                             bleg_method: 'GET'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/',
                     method: 'POST',
                     data: {
                       legs: 'both',
                       aleg_url: 'http://www.aleg.url',
                       bleg_url: 'http://www.bleg.url',
                       aleg_method: 'POST',
                       bleg_method: 'GET'
                     })
  end

  it 'throws exception while transferring a call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/callUpdateResponse.json')
    mock(202, JSON.parse(contents))
    expect do
      JSON.parse(to_json_update(@api.calls
                                         .update(id,
                                                 legs: 'both',
                                                 aleg_url: 'http://www.aleg.url',
                                                 aleg_method: 'POST',
                                                 bleg_method: 'GET')))
    end
      .to raise_error(
        Plivo::Exceptions::InvalidRequestError,
        'leg is both, aleg_url & bleg_url have to be specified'
      )
  end

  it 'deletes the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.calls.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'records the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallRecordCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_record(@api.calls
                                         .record(id,
                                                 transcription_method: 'POST',
                                                 callback_url: 'http://abc.cba',
                                                 time_limit: 123,
                                                 file_format: 'wav',
                                                 transcription_type: 'hybrid'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Record/',
                     method: 'POST',
                     data: {
                       transcription_method: 'POST',
                       callback_url: 'http://abc.cba',
                       time_limit: 123,
                       file_format: 'wav',
                       transcription_type: 'hybrid'
                     })
  end

  it 'stop recording the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.calls.stop_record(id, 'http://url.com')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Record/',
                     method: 'DELETE',
                     data: {
                       URL: 'http://url.com'
                     })
  end

  it 'plays audio in the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallPlayCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.calls
                                     .play(id,
                                           %w[http://1.com http://2.com],
                                           loop: true,
                                           length: 120,
                                           legs: 'aleg'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Play/',
                     method: 'POST',
                     data: {
                       urls: 'http://1.com,http://2.com',
                       loop: true,
                       length: 120,
                       legs: 'aleg'
                     })
  end

  it 'stop playing audio in the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.calls.stop_play(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Play/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'speaks in the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallPlayCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.calls
                                         .speak(id,
                                                'Speak this',
                                                loop: true))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Speak/',
                     method: 'POST',
                     data: {
                       text: 'Speak this',
                       loop: true
                     })
  end

  it 'stop speaking in the call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.calls.stop_speak(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Speak/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'send digits on a call' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    digits = 'Speak this'
    contents = File.read(Dir.pwd + '/spec/mocks/liveCallDtmfCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.calls
                                         .send_digits(id,
                                                      digits,
                                                      'both'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/DTMF/',
                     method: 'POST',
                     data: {
                       digits: digits,
                       leg: 'both'
                     })
  end

  it 'cancel call request' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.calls.cancel_request(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Request/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'start stream' do
    id = 'MAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/streamStartCreateResponse.json')
    response = File.read(Dir.pwd + '/spec/mocks/streamStartCreateResponses.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.calls
                                         .start_stream(id,
                                                'wss://mystream.ngrok.io/audiostream'))))
      .to eql(JSON.parse(response))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Call/' + id + '/Stream/',
                     method: 'POST',
                     data: {
                       service_url: 'wss://mystream.ngrok.io/audiostream'
                     })
  end
end
