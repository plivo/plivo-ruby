require 'rspec'

describe 'TollfreeVerifications test' do
  def to_json(tfverificationobj)
    {
      created: tfverificationobj.created,
      number: tfverificationobj.number,
      last_modified: tfverificationobj.last_modified,
      callback_method: tfverificationobj.callback_method,
      callback_url: tfverificationobj.callback_url,
      extra_data: tfverificationobj.extra_data,
      additional_information: tfverificationobj.additional_information,
      message_sample: tfverificationobj.message_sample,
      optin_image_url: tfverificationobj.optin_image_url,
      optin_type: tfverificationobj.optin_type,
      profile_uuid: tfverificationobj.profile_uuid,
      error_message: tfverificationobj.error_message,
      status: tfverificationobj.status,
      usecase: tfverificationobj.usecase,
      usecase_summary: tfverificationobj.usecase_summary,
      uuid: tfverificationobj.uuid,
      volume: tfverificationobj.volume,
    }.to_json
  end

  def to_json_update(tfverificationobj)
    {
      api_id: tfverificationobj.api_id,
      message: tfverificationobj.message
    }.to_json
  end

  def to_json_create(tfverificationobj)
    {
      message: tfverificationobj.message,
      uuid: tfverificationobj.uuid,
      api_id: tfverificationobj.api_id
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

  it 'fetches details of  tollfree verification' do
      contents = File.read(Dir.pwd + '/spec/mocks/tollfreeverificationGetResponse.json')
      mock(200, JSON.parse(contents))
      expect(JSON.parse(to_json(@api.tollfree_verifications.get('SAXXXXXXXXXXXXXXXXXX'))))
        .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/TollfreeVerification/'\
                       'SAXXXXXXXXXXXXXXXXXX/',
                       method: 'GET',
                       data: nil)
    end

  it 'deletes the tollfree verifications' do
      id = 'SAXXXXXXXXXXXXXXXXXX'
      contents = '{}'
      mock(204, JSON.parse(contents))
      @api.tollfree_verifications.delete(id)
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/TollfreeVerification/' + id + '/',
                       method: 'DELETE',
                       data: nil)
  end

  it 'creates a tollfree verification with optional link/message fields' do
      contents = File.read(Dir.pwd + '/spec/mocks/tollfreeVerificationCreateResponse.json')
      mock(201, JSON.parse(contents))
      @api.tollfree_verifications.create(
        '18888888888', 'PROXY', 'summary text', 'a4c95b2c-a3ce-4dc4-b12c-b0f7b48f6c8c',
        'VERBAL', 'https://example.com/optin.png', '1,000', 'sample message',
        'https://example.com/callback', 'POST', 'extra data', 'additional info',
        'https://example.com/terms', 'https://example.com/privacy',
        'optin message text', 'help message text')
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/TollfreeVerification/',
                       method: 'POST',
                       data: {
                         number: '18888888888',
                         usecase: 'PROXY',
                         usecase_summary: 'summary text',
                         profile_uuid: 'a4c95b2c-a3ce-4dc4-b12c-b0f7b48f6c8c',
                         optin_type: 'VERBAL',
                         optin_image_url: 'https://example.com/optin.png',
                         volume: '1,000',
                         message_sample: 'sample message',
                         callback_url: 'https://example.com/callback',
                         callback_method: 'POST',
                         extra_data: 'extra data',
                         additional_information: 'additional info',
                         terms_and_conditions_link: 'https://example.com/terms',
                         privacy_policy_link: 'https://example.com/privacy',
                         optin_message: 'optin message text',
                         help_message: 'help message text'
                       })
  end

  it 'updates a tollfree verification with optional link/message fields' do
      id = 'SAXXXXXXXXXXXXXXXXXX'
      contents = File.read(Dir.pwd + '/spec/mocks/tollfreeVerificationUpdateResponse.json')
      mock(202, JSON.parse(contents))
      @api.tollfree_verifications.update(id, {
        terms_and_conditions_link: 'https://example.com/terms',
        privacy_policy_link: 'https://example.com/privacy',
        optin_message: 'optin message text',
        help_message: 'help message text'
      })
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/TollfreeVerification/' + id + '/',
                       method: 'POST',
                       data: {
                         terms_and_conditions_link: 'https://example.com/terms',
                         privacy_policy_link: 'https://example.com/privacy',
                         optin_message: 'optin message text',
                         help_message: 'help message text'
                       })
  end
end