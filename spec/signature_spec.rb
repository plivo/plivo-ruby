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


  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
      "https://answer.url",
			"12345",
			"pETJPPuss8j7tRO1V76pMhutvY1EbD905bph1xlJQhE=",
			"my_auth_token",
      "GET",
      {
        "CallUUID" => "97ceeb52-58b6-11e1-86da-77300b68f8bb",
        "Duration" => "300",
      },
    )

    expect(sig_matching_result).to eql(true)
  end


  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
      "https://answer.url",
			"12345",
			"oU2FndD/RdBLcBReK1rNidA6c6kh9+luV1RcvXJ/ciw=",
			"my_auth_token",
      "POST",
      {
        "Duration" => "300",
        "CallUUID" => "97ceeb52-58b6-11e1-86da-77300b68f8bb",
      },
    )

    expect(sig_matching_result).to eql(true)
  end


  it 'should fail' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
      "https://answer.url",
			"12345",
			"rXj4UwTSVxH6Kj+W0qX8LaCvVOOvmzPGzY8sQVn3d1I+",
			"my_auth_token",
      "GET",
      {
        "CallUUID" => "97ceeb52-58b6-11e1-86da-77300b68f8bb",
				"Duration" => "300",
      },
    )

    expect(sig_matching_result).to eql(false)
  end


  it 'should fail' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
      "https://answer.url",
			"12345",
			"rXj4UwTSVxH6Kj+W0qX8LaCvVOOvmzPGzY8sQVn3d1I+",
			"my_auth_token",
      "POST",
      {
        "CallUUID" => "97ceeb52-58b6-11e1-86da-77300b68f8bb",
				"Duration" => "300",
      },
    )

    expect(sig_matching_result).to eql(false)
  end
end
