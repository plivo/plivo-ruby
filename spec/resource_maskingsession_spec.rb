require 'rspec'

describe 'MaskingSession test' do
  def to_json(masking_session)
    {
      first_party: masking_session.first_party,
      second_party: masking_session.second_party,
      virtual_number: masking_session.virtual_number,
      status: masking_session.status,
      initiate_call_to_first_party: masking_session.initiate_call_to_first_party,
      session_uuid: masking_session.session_uuid,
      callback_url: masking_session.callback_url,
      callback_method: masking_session.callback_method,
      created_time: masking_session.created_time,
      modified_time: masking_session.modified_time,
      expiry_time: masking_session.expiry_time,
      duration: masking_session.duration,
      amount: masking_session.amount,
      call_time_limit: masking_session.call_time_limit,
      ring_timeout: masking_session.ring_timeout,
      first_party_play_url: masking_session.first_party_play_url,
      second_party_play_url: masking_session.second_party_play_url,
      record: masking_session.record,
      record_file_format: masking_session.record_file_format,
      recording_callback_url: masking_session.recording_callback_url,
      recording_callback_method: masking_session.recording_callback_method,
      interaction: masking_session.interaction,
      total_call_amount: masking_session.total_call_amount,
      total_call_count: masking_session.total_call_count,
      total_call_billed_duration: masking_session.total_call_billed_duration,
      total_session_amount: masking_session.total_session_amount,
      last_interaction_time: masking_session.last_interaction_time,
      is_pin_authentication_required: masking_session.is_pin_authentication_required,
      generate_pin: masking_session.generate_pin,
      generate_pin_length: masking_session.generate_pin_length,
      second_party_pin: masking_session.second_party_pin,
      pin_prompt_play: masking_session.pin_prompt_play,
      pin_retry: masking_session.pin_retry,
      pin_retry_wait: masking_session.pin_retry_wait,
      incorrect_pin_play: masking_session.incorrect_pin_play,
      unknown_caller_play: masking_session.unknown_caller_play
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_update(masking_session)
    {
      api_id: masking_session.api_id,
      message: masking_session.message
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_create(masking_session)
    {
      api_id: masking_session.api_id,
      session_uuid: masking_session.session_uuid,
      virtual_number: masking_session.virtual_number,
      message: masking_session.message,
      session: masking_session.session
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

  it 'deletes the session_uuid' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents).reject { |_, v| v.nil? })
    @api.maskingsession.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Masking/Session/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
