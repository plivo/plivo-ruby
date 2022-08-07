require 'rspec'

describe 'Token test' do
  def to_json(token)
    {
      api_id: token.api_id,
      message: token.message
    }.reject { |_, v| v.nil? }.to_json
  end

  it 'create token' do
    contents = File.read(Dir.pwd + '/spec/mocks/tokenCreateResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json(@api.token
                           .create(
                             params = {
                               iss: 'MAXXXXXXXXXXXXXXXXXX'
                             }, :per=>{:voice=>{}}))

    contents = JSON.parse(contents)

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/JWT/Token/',
                     method: 'POST',
                     data: {
                       :iss=>{
                         :iss=>"MAXXXXXXXXXXXXXXXXXX"
                       }
                     }, :per=>{:voice=>{}})
  end
end

