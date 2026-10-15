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
        "https://plivobin.non-prod.plivops.com/api/v1/validate_signature03.xml/?a=b&c=d",
        "31627761595286130198",
        "k7Pusd4OxCIjR5IfA9iedDNu/h/gbdYqdzG/MiYtd1c=",
        "Y2Q2ZDgxZmY5YWRiOTI5YmQ1Njg0MTAxZWIyOTc4",
        "POST",
        {
            "Direction" => "outbound",
            "From" => "19792014278",
            "ALegUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallStatus" => "in-progress",
            "BillRate" => "0.002",
            "ParentAuthID" => "MANWVLYTK4ZWU1YTY4QA",
            "To" => "sip:PlivoSignature382029104058171078704104@phone-qa.voice.plivodev.com",
            "ALegRequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "RequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "SIP-H-To" => "<sip:PlivoSignature382029104058171078704104@52.9.11.55;transport=udp>;tag=1",
            "SessionStart" => "2020-04-08 11:34:33.238707",
            "Event" => "StartApp",
        },
    )


    expect(sig_matching_result).to eql(true)
  end


  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
        "https://plivobin.non-prod.plivops.com/api/v1/validate_signature03.xml/?a=b&c=d",
        "31627761595286130198",
        "UBq8jAtd32wR8EK9VgxbBn4n5rpI/l1H9iN4WfSEHFQ=",
        "Y2Q2ZDgxZmY5YWRiOTI5YmQ1Njg0MTAxZWIyOTc4",
        "GET",
        {
            "Direction" => "outbound",
            "From" => "19792014278",
            "ALegUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallStatus" => "in-progress",
            "BillRate" => "0.002",
            "ParentAuthID" => "MANWVLYTK4ZWU1YTY4QA",
            "To" => "sip:PlivoSignature382029104058171078704104@phone-qa.voice.plivodev.com",
            "ALegRequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "RequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "SIP-H-To" => "<sip:PlivoSignature382029104058171078704104@52.9.11.55;transport=udp>;tag=1",
            "SessionStart" => "2020-04-08 11:34:33.238707",
            "Event" => "StartApp",
        },
        )


    expect(sig_matching_result).to eql(true)
  end

  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
        "https://plivobin.non-prod.plivops.com/api/v1/validate_signature03.xml",
        "31627761595286130198",
        "iAjE5QqI37mbkYe4w3jTMudqEzbDufdqi7sYwTu64e0=",
        "Y2Q2ZDgxZmY5YWRiOTI5YmQ1Njg0MTAxZWIyOTc4",
        "POST",
        {
            "Direction" => "outbound",
            "From" => "19792014278",
            "ALegUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallStatus" => "in-progress",
            "BillRate" => "0.002",
            "ParentAuthID" => "MANWVLYTK4ZWU1YTY4QA",
            "To" => "sip:PlivoSignature382029104058171078704104@phone-qa.voice.plivodev.com",
            "ALegRequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "RequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "SIP-H-To" => "<sip:PlivoSignature382029104058171078704104@52.9.11.55;transport=udp>;tag=1",
            "SessionStart" => "2020-04-08 11:34:33.238707",
            "Event" => "StartApp",
        },
        )


    expect(sig_matching_result).to eql(true)
  end

  it 'should succeed' do
    sig_matching_result = Plivo::Utils.valid_signatureV3?(
        "https://plivobin.non-prod.plivops.com/api/v1/validate_signature03.xml",
        "31627761595286130198",
        "i/MQsaQSAd6fiKhOh2qeeeLHZ9faldADSb3/7+Akfbc=",
        "Y2Q2ZDgxZmY5YWRiOTI5YmQ1Njg0MTAxZWIyOTc4",
        "GET",
        {
            "Direction" => "outbound",
            "From" => "19792014278",
            "ALegUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallStatus" => "in-progress",
            "BillRate" => "0.002",
            "ParentAuthID" => "MANWVLYTK4ZWU1YTY4QA",
            "To" => "sip:PlivoSignature382029104058171078704104@phone-qa.voice.plivodev.com",
            "ALegRequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "CallUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "RequestUUID" => "3e82ae9d-2c78-4d85-b1a4-6eae7dbafb36",
            "SIP-H-To" => "<sip:PlivoSignature382029104058171078704104@52.9.11.55;transport=udp>;tag=1",
            "SessionStart" => "2020-04-08 11:34:33.238707",
            "Event" => "StartApp",
        },
        )


    expect(sig_matching_result).to eql(true)
  end
end

describe 'Scoped token V3 signature validation' do
  let(:token_one) { ['PLV', 'obLD1OX2BxgpOktcbX6PkBEiM0RVZneImaq7zN3u_wA'].join }
  let(:token_two) { 'PLV' + 'A' * 43 }
  let(:nonce) { '01456268273535255990' }
  let(:post_url) { 'https://acme.example.com/sms/status' }
  let(:post_params) { { 'MessageUUID' => '6f1c2a90-0d7e-4b1e-9c11-1d2e3f4a5b6c', 'Status' => 'delivered', 'To' => '14155550100' } }
  let(:post_sig) { 'Kxo1ZuQEWE578HnfEhiJvLjXNzZXYPvkZDKNq9s4kvk=' }
  let(:get_url) { 'https://acme.example.com/answer?From=14155550100&CallUUID=abc' }
  let(:get_sig) { 'nr+QWHZTVoEP0rWEEWMeWjgKRzfOOuBhJvJqQQ8ZC2s=' }

  it 'derives the signing key' do
    expect(Plivo::Utils.derive_signing_key(token_one).unpack('H*')[0]).to eql('e55b316ef14f5830de74d2cc2ae794b87c6c349f577d2fabd648884afba6c7ca')
    expect(Plivo::Utils.derive_signing_key(token_two).unpack('H*')[0]).to eql('c89d8ad56ac99e1a8def8cecce07ffb55332fe813673be81df8b1297d1206368')
  end

  it 'validates POST and GET vectors' do
    expect(Plivo::Utils.valid_signatureV3_scoped?(post_url.dup, nonce, post_sig, token_one, 'POST', post_params)).to eql(true)
    expect(Plivo::Utils.valid_signatureV3_scoped?(get_url.dup, nonce, get_sig, token_one, 'GET')).to eql(true)
  end

  it 'accepts any of several comma-separated signatures' do
    expect(Plivo::Utils.valid_signatureV3_scoped?(post_url.dup, nonce, "bogus,#{post_sig}", token_one, 'POST', post_params)).to eql(true)
  end

  it 'rejects wrong token, tampered params and the auth-token validator' do
    expect(Plivo::Utils.valid_signatureV3_scoped?(post_url.dup, nonce, post_sig, token_two, 'POST', post_params)).to eql(false)
    expect(Plivo::Utils.valid_signatureV3_scoped?(post_url.dup, nonce, post_sig, token_one, 'POST', post_params.merge('Status' => 'failed'))).to eql(false)
    expect(Plivo::Utils.valid_signatureV3?(post_url.dup, nonce, post_sig, token_one, 'POST', post_params)).to eql(false)
  end

  context 'with a list of keys' do
    let(:auth_token) { 'MjEyOWU5MGVlM2NjZDY1ZTNmZTU2NjZhZGNjMTc5' }
    let(:auth_sig) { Plivo::Utils.compute_signatureV3?(Plivo::Utils.generate_url?(post_url.dup, post_params, 'POST'), auth_token, nonce) }

    def validate(signature, keys)
      Plivo::Utils.valid_signatureV3_scoped?(post_url.dup, nonce, signature, keys, 'POST', post_params)
    end

    it 'accepts a signature made with the scoped token or the auth token' do
      expect(validate(post_sig, [token_one, auth_token])).to eql(true)
      expect(validate(auth_sig, [token_one, auth_token])).to eql(true)
      expect(validate("#{post_sig},#{auth_sig}", [token_two, auth_token])).to eql(true)
    end

    it 'rejects when no key matches' do
      expect(validate(post_sig, [token_two])).to eql(false)
      expect(validate(post_sig, [])).to eql(false)
    end

    it 'skips nil and empty entries' do
      expect(validate(post_sig, [nil, '', token_one])).to eql(true)
    end
  end
end
