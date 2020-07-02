require 'rspec'

describe 'MultiPartyCalls test' do

  def to_json_MPC_funcs(mpc)
    {
        "api_id": mpc["api_id"],
        "message": mpc["message"],
        "request_uuid": mpc["request_uuid"]
    }.to_json
  end

  it 'lists MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsListMpcResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.list
    response.is_a?( Plivo::Resources::MultiPartyCallInterface)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/',
                     method: 'GET',
                     data: {})
  end

  it 'gets MPC' do
    contents = '{}'
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.get(nil, 'Chamblee')
    response.is_a?( Plivo::Resources::MultiPartyCall)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Chamblee/',
                     method: 'GET'
                    )
  end

  it 'add participant to MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsAddParticipantResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.add_participant('Agent', 'Voice', nil,nil,nil ,'1234-5678-4321-0987')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Participant/',
                     method: 'POST',
                     data:{
                         'exit_sound_method': 'GET',
                         'exit_sound': 'beep:2',
                         'enter_sound_method': 'GET',
                         'enter_sound': 'beep:1',
                         'relay_dtmf_inputs': false,
                         'end_mpc_on_exit': false,
                         'start_mpc_on_enter': true,
                         'hold': false, 'mute': false,
                         'coach_mode': true,
                         'stay_alone': false,
                         'status_callback_events': 'mpc-state-changes,participant-state-changes',
                         'record_file_format': 'mp3',
                         'record': false,
                         'on_exit_action_method': 'POST',
                         'status_callback_method': 'GET',
                         'recording_callback_method': 'GET',
                         'customer_hold_music_method': 'GET',
                         'agent_hold_music_method': 'GET',
                         'wait_music_method': 'GET',
                         'max_participants': 10,
                         'max_duration': 14400,
                         'ring_timeout': 45,
                         'dial_music': 'Real',
                         'confirm_key_sound_method': 'GET',
                         'call_status_callback_method': 'POST',
                         'call_uuid': '1234-5678-4321-0987',
                         'role': 'Agent'
                     })
  end

  it 'starts MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartMpcResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.start(nil,'Voice')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/',
                     method: 'POST',
                     data:{
                         "status" => 'active'
                     })
  end

  it 'starts MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartMpcResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.start(nil,'Voice')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/',
                     method: 'POST',
                     data:{
                         "status" => 'active'
                     })
  end

  it 'ends MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsEndMpcResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.stop(nil,'Voice')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/',
                     method: 'DELETE')
  end

  it 'start MPC recording' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartRecordingResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.start_recording(nil,'Voice','wav','https://plivo.com/status','POST')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/',
                     method: 'POST',
                     data: {'file_format': 'wav',
                            'status_callback_url': 'https://plivo.com/status',
                            'status_callback_method': 'POST'
                     })
  end

  it 'stop MPC recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.stop_recording(nil,'Voice')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/',
                     method: 'DELETE')
  end

  it 'pause MPC recording' do
  contents = '{}'
  mock(204, JSON.parse(contents))
  @api.multipartycalls.pause_recording(nil,'Voice')
  compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/Pause/',
                   method: 'POST')
  end

  it 'resume MPC recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.resume_recording(nil,'Voice')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/Resume/',
                     method: 'POST')
  end

  it 'lists MPC participants' do
    contents = '{}'
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.list_participants('12345678-90123456')
    response.is_a?( Plivo::Resources::MultiPartyCall)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/',
                     method: 'GET',
                     data: {})
  end

  it 'update MPC participant' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsUpdateMpcParticipant.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_funcs(@api.multipartycalls.update_participant(10,'12345678-90123456',nil,false ,true)))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/10/',
                     method: 'POST',
                     data: {'coach_mode': false,
                            'mute': true
                     })
  end

  it 'kick MPC participant' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.kick_participant(10, '12345678-90123456')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/10/',
                     method: 'DELETE')
  end

  it 'get MPC participant' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsGetParticipantResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.get_participant(12, '12345678-90123456')
    response.is_a?( Plivo::Resources::MultiPartyCallParticipant)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/12/',
                     method: 'GET')
  end

end
