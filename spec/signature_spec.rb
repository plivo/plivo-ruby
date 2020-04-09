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
