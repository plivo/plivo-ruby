require 'rspec'

describe 'Recordings test' do
  def to_json(recording)
    {
      add_time: recording.add_time,
      api_id: recording.api_id,
      call_uuid: recording.call_uuid,
      conference_name: recording.conference_name,
      monthly_recording_storage_amount: recording.monthly_recording_storage_amount,
      recording_duration_ms: recording.recording_duration_ms,
      recording_end_ms: recording.recording_end_ms,
      recording_format: recording.recording_format,
      recording_id: recording.recording_id,
      recording_start_ms: recording.recording_start_ms,
      recording_storage_duration: recording.recording_storage_duration,
      recording_storage_rate: recording.recording_storage_rate,
      recording_type: recording.recording_type,
      recording_url: recording.recording_url,
      resource_uri: recording.resource_uri,
      rounded_recording_duration: recording.rounded_recording_duration
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

  it 'fetches details of a recording' do
    contents = File.read(Dir.pwd + '/spec/mocks/recordingGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.recordings.get('SAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Recording/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all recordings' do
    contents = File.read(Dir.pwd + '/spec/mocks/recordingListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.recordings
                                .list(
                                  subaccount: 'SAXXXXXXXXXXXXXXXXXX',
                                  offset: 4,
                                  call_uuid: 'abcabcabc'
                                ))

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.delete('api_id')
      obj
    end
    contents['objects'] = objects

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Recording/',
                     method: 'GET',
                     data: {
                       subaccount: 'SAXXXXXXXXXXXXXXXXXX',
                       offset: 4,
                       call_uuid: 'abcabcabc'
                     })
  end

  it 'deletes the recording' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.recordings.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Recording/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
