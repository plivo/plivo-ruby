require 'rspec'

describe 'Token test' do
  def to_json(token)
    {
      iss:token.iss
    }.reject { |_, v| v.nil? }.to_json
  end
  def to_json_create(token)
    {
      api_id: token.api_id,
      token: token.token

    }.reject { |_, v| v.nil? }.to_json
  end
  

  it 'creates a token' do
    contents = File.read(Dir.pwd + '/spec/mocks/tokenCreateResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.token
                                         .create('MAXXXXXXXXXXXXXXXXXX'))))
      .to eql(JSON.parse(contents).reject { |_, v| v.nil? })
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/token/',
                     method: 'POST',
                     data: {
                        iss:'MAXXXXXXXXXXXXXXXXXX',
                     })
  end
end
