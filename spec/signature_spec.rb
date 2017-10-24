require 'rspec'
require 'plivo'

describe 'Signature validation test' do
  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signature?(
      'https://answer.url',
      '12345',
      'ehV3IKhLysWBxC1sy8INm0qGoQYdYsHwuoKjsX7FsXc=',
      'my_auth_token'
    )

    expect(sig_matching_result).to eql(true)
  end

  it 'should fail' do
    sig_matching_result = Plivo::Utils.valid_signature?(
      'https://answer.url',
      '12345',
      'ehV3IKhLysWBxC1sy8INm0qGoQYdYsHwuoKjsX7FsXc=',
      'my_auth_tokens'
    )

    expect(sig_matching_result).to eql(false)
  end
end
