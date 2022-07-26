require 'rspec'

describe 'Token test' do
  def to_json(token)
    {
      api_id: token.api_id,
      message: token.message
    }.to_json
  end
  it 'create token' do
    contents = File.read(Dir.pwd + '/spec/mocks/tokenCreateResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json(@api.token
                           .create(
                               iss: 'MAXXXXXXXXXXXXXXXXXX',
                               sub: 'kowshik',
                               nbf: '1658646749',
                               exp: '1658696749',
                               "per": {
                                 "voice": {
                                   "incoming_allow": 'true',
                                   "outgoing_allow": 'true'
                                 }
                               },
                               app: 'default'
                           ))

    contents = JSON.parse(contents)

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/JWT/Token/',
                     method: 'POST',
                     data: {
                       iss: 'MAXXXXXXXXXXXXXXXXXX',
                       sub: 'kowshik',
                       nbf: '1658646749',
                       exp: '1658696749',
                       "per": {
                         "voice": {
                           "incoming_allow": '',
                           "outgoing_allow": ''
                         }
                       },
                       app: 'default'
                     }, :per=>{:voice=>{}})
  end
end
