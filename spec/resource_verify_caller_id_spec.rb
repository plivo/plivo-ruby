require 'rspec'
require 'json'
require_relative 'spec_helper'

describe 'Verify test' do

  def to_json_initate(verify)
    {
      message: verify.message,
      verification_uuid: verify.verification_uuid,
      api_id: verify.api_id
    }.to_json
  end

  def to_json_verify(verify)
    {
      api_id: verify.api_id,
      alias: verify.alias,
      channel: verify.channel,
      country: verify.country,
      created_at: verify.created_at,
      phone_number: verify.phone_number,
      verification_uuid: verify.verification_uuid,
    }.to_json
  end



  it 'initiates verification of a caller id' do
    contents = File.read(Dir.pwd + '/spec/mocks/initiateVerifyResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_initate(@api.verify_caller_id
                                         .initiate("919999999999", nil, nil
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/VerifiedCallerId/',
                     method: 'POST',
                     data: {
                       phone_number: '919999999999',
                       channel: nil,
                       alias: nil
                     })
  end

  it 'verifies a caller id' do
    contents = File.read(Dir.pwd + '/spec/mocks/verifyCallerIdResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_verify(@api.verify_caller_id
                                         .verify("test-uuid", "123456"
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/VerifiedCallerId/Verification/test-uuid/',
                     method: 'POST',
                     data: {
                       otp: '123456',
                     })
  end



end