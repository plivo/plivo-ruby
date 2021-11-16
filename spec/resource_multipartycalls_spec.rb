require 'rspec'
require 'json'
describe 'MultiPartyCalls test' do

  def to_json_MPC_add_participant(mpc)
    {
        "api_id": mpc["api_id"],
        "calls": mpc["calls"],
        "message": mpc["message"],
        "request_uuid": mpc["request_uuid"]
    }.to_json
  end

  def to_json_MPC_start_record(mpc)
    {
        "api_id": mpc["api_id"],
        "message": mpc["message"],
        "recording_id": mpc["recording_id"],
        "recording_url": mpc["recording_url"]
    }.to_json
  end

  def to_json_MPC_start_play(mpc)
    {
      "api_id": mpc["api_id"],
      "message": mpc["message"],
      "mpcMemberId": mpc["mpcMemberId"],
      "mpcName": mpc["mpcName"]
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
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsGetResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.get({friendly_name: 'Chamblee'})
    response.is_a?( Plivo::Resources::MultiPartyCall)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Chamblee/',
                     method: 'GET'
                    )
  end

  it 'add participant to MPC' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsAddParticipantResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_add_participant(@api.multipartycalls.add_participant({role: 'Agent', friendly_name: 'Voice',
                                                                                        call_uuid: '1234-5678-4321-0987'})))).to eql(JSON.parse(contents))
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
                         'role': 'Agent',
                         'caller_name': nil,
                         'delay_dial': 0
                     })
  end

  it 'starts MPC' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.start({friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/',
                     method: 'POST',
                     data:{
                         "status" => 'active'
                     })
  end

  it 'ends MPC' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.stop({friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/',
                     method: 'DELETE')
  end

  it 'start MPC recording' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartRecordingResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_start_record(@api.multipartycalls.start_recording({friendly_name: 'Voice', file_format: 'wav',
                                                                                     status_callback_url: 'https://plivo.com/status',
                                                                                     status_callback_method: 'POST'})))).to eql(JSON.parse(contents))
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
    @api.multipartycalls.stop_recording({friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/',
                     method: 'DELETE')
  end

  it 'pause MPC recording' do
  contents = '{}'
  mock(204, JSON.parse(contents))
  @api.multipartycalls.pause_recording({friendly_name: 'Voice'})
  compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/Pause/',
                   method: 'POST')
  end

  it 'resume MPC recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.resume_recording({friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Record/Resume/',
                     method: 'POST')
  end

  it 'lists MPC participants' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsListParticipantsResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.list_participants({uuid: '12345678-90123456'})
    response.is_a?( Plivo::Resources::MultiPartyCall)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/',
                     method: 'GET',
                     data: {})
  end

  it 'update MPC participant' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsUpdateMpcParticipant.json')
    mock(202, JSON.parse(contents))
    response = @api.multipartycalls.update_participant({member_id: 10, uuid: '12345678-90123456', coach_mode: false, mute: true})
    response.is_a?( Plivo::Resources::MultiPartyCallParticipant)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/10/',
                     method: 'POST',
                     data: {'coach_mode': false,
                            'mute': true
                     })
  end

  it 'kick MPC participant' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.kick_participant({member_id: 10, uuid: '12345678-90123456'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/10/',
                     method: 'DELETE')
  end

  it 'get MPC participant' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsGetParticipantResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.multipartycalls.get_participant({member_id: 12, uuid: '12345678-90123456'})
    response.is_a?( Plivo::Resources::MultiPartyCallParticipant)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/uuid_12345678-90123456/Participant/12/',
                     method: 'GET')
  end

  it 'starts MPC Participant Recording' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartParticipantRecordingResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_start_record(@api.multipartycalls.start_participant_recording({member_id: 10, friendly_name: 'Voice', file_format: 'wav',
                                                                                     status_callback_url: 'https://plivo.com/status',
                                                                                     status_callback_method: 'POST'})))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Participant/10/Record/',
                     method: 'POST',
                     data: {'file_format': 'wav',
                            'status_callback_url': 'https://plivo.com/status',
                            'status_callback_method': 'POST'
                     })
  end

  it 'stops MPC Participant Recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.stop_participant_recording({member_id: 10, friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Participant/10/Record/',
                     method: 'DELETE')
  end

  it 'pauses MPC Participant Recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.pause_participant_recording({member_id: 10, friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Participant/10/Record/Pause/',
                     method: 'POST')
  end

  it 'resumes MPC Participant Recording' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.resume_participant_recording({member_id: 10, friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Participant/10/Record/Resume/',
                     method: 'POST')
  end

  it 'starts MPC Member Play Audio' do
    contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallsStartMemberPlayAudioResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_MPC_start_play(@api.multipartycalls.start_play_audio({member_id: 10, friendly_name: 'Voice',
                                                                                    url: 'https://s3.amazonaws.com/XXX/XXX.mp3'})))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Member/10/Play/',
                     method: 'POST',
                     data: {'url': 'https://s3.amazonaws.com/XXX/XXX.mp3'})
  end

  it 'stops MPC Member Play Audio' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.multipartycalls.stop_play_audio({member_id: 10, friendly_name: 'Voice'})
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/MultiPartyCall/name_Voice/Member/10/Play/',
                     method: 'DELETE')
  end

end
