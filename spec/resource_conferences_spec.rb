require 'rspec'

describe 'Conferences test' do
  def to_json(conference)
    members_json = conference.members.map do |member|
      JSON.parse(to_json_member(member))
    end
    {
      conference_name: conference.conference_name,
      conference_run_time: conference.conference_run_time,
      conference_member_count: conference.conference_member_count,
      members: members_json,
      api_id: conference.api_id
    }.to_json
  end

  def to_json_member(member)
    {
      muted: member['muted'],
      member_id: member['member_id'],
      deaf: member['deaf'],
      from: member['from'],
      to: member['to'],
      caller_name: member['caller_name'],
      direction: member['direction'],
      call_uuid: member['call_uuid'],
      join_time: member['join_time']
    }.to_json
  end

  def to_json_list(list_object)
    {
      api_id: list_object[:api_id],
      conferences: list_object[:conferences]
    }.to_json
  end

  def to_json_update(conference)
    {
      api_id: conference.api_id,
      message: conference.message
    }.to_json
  end

  def to_json_member_actions(conference)
    {
      api_id: conference.api_id,
      message: conference.message,
      member_id: conference.member_id
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

  it 'fetches details of a conference' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.conferences.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all conferences' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.conferences
                                     .list)
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/',
                     method: 'GET',
                     data: nil)
  end

  it 'delete a conference' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceDeleteResponse.json')
    mock(204, JSON.parse(contents))
    response = to_json_update(@api.conferences
                                .delete('conf name'))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/conf name/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'deletes all conferences' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceDeleteAllResponse.json')
    mock(204, JSON.parse(contents))
    response = to_json_update(@api.conferences
                                .delete_all)
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference//',
                     method: 'DELETE',
                     data: nil)
  end

  it 'hangup member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberDeleteResponse.json')
    mock(204, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                      .delete_member('my conf', '1'))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'kick member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberKickCreateResponse.json')
    mock(202, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .kick_member('my conf', '1'))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Kick/',
                     method: 'POST',
                     data: nil)
  end

  it 'mute member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberMuteCreateResponse.json')
    mock(202, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .mute_member('my conf', %w[1]))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Mute/',
                     method: 'POST',
                     data: nil)
  end

  it 'unmute member' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.conferences.unmute_member('my conf', %w[1 3])
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1,3/Mute/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'play audio to member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberPlayCreateResponse.json')
    mock(202, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .play_member('my conf', %w[1], 'http://audio.url'))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Play/',
                     method: 'POST',
                     data: {
                       url: 'http://audio.url'
                     })
  end

  it 'stop playing audio to member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberPlayDeleteResponse.json')
    mock(204, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .stop_play_member('my conf', %w[1]))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Play/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'speak text to member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberSpeakCreateResponse.json')
    mock(202, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .speak_member('my conf', %w[1], 'text to speak'))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Speak/',
                     method: 'POST',
                     data: {
                       text: 'text to speak'
                     })
  end

  it 'stop speaking text to member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberSpeakDeleteResponse.json')
    mock(204, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .stop_speak_member('my conf', %w[1]))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Speak/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'deaf member' do
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceMemberDeafCreateResponse.json')
    mock(202, JSON.parse(contents))
    response = to_json_member_actions(@api.conferences
                                          .deaf_member('my conf', %w[1]))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Deaf/',
                     method: 'POST',
                     data: nil)
  end

  it 'undeaf member' do
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.conferences.undeaf_member('my conf', %w[1])
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/my conf/Member/1/Deaf/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'records the conference' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/conferenceRecordCreateResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_record(@api.conferences
                                         .record(id,
                                                 transcription_method: 'POST',
                                                 callback_url: 'http://abc.cba'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/' + id + '/Record/',
                     method: 'POST',
                     data: {
                       transcription_method: 'POST',
                       callback_url: 'http://abc.cba'
                     })
  end

  it 'stop recording the conference' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.conferences.stop_record(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Conference/' + id + '/Record/',
                     method: 'DELETE',
                     data: nil)
  end
end
