require 'rspec'

describe 'TollfreeVerifications test' do
  def to_json(tfverificationobj)
    {
      created: tfverificationobjcreated,
      number: tfverificationobj.number,
      lastModified: tfverificationobj.last_modified,
      callbackMethod: tfverificationobj.callback_method,
      callbackUrl: tfverificationobj.callback_url,
      extraData: tfverificationobj.extra_data,
      additionalInformation: tfverificationobj.additional_information,
      messageSample: tfverificationobj.message_sample,
      optinImageUrl: tfverificationobj.optin_image_url,
      optinType: tfverificationobj.optin_type,
      profileUuid: tfverificationobj.profile_uuid,
      errorMessage: tfverificationobj.error_message,
      status: tfverificationobj.status,
      usecase: tfverificationobj.usecase,
      usecaseSummary: tfverificationobj.usecase_summary,
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
      contents = File.read(Dir.pwd + '/spec/mocks/tollfreeVerificationGetResponse.json')
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