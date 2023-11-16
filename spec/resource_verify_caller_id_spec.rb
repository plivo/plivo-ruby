require 'rspec'
require 'json'


describe 'Verify test' do

  it 'initiates verification of a caller id' do
    contents = File.read(Dir.pwd + '/spec/mocks/initiateVerifyResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.verify_caller_id
                                         .initiate("919999999"
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/VerifiedCallerId',
                     method: 'POST',
                     data: {
                       phone_number: '919999999'
                     })
  end

end