require 'rspec'

describe 'phlos test' do

  before :each do
    contents = File.read(Dir.pwd + '/spec/mocks/phloGetResponse.json')
    mock(200, JSON.parse(contents))
    @phlo = @phlo_client.phlo.get('e564a84a-7910-4447-b16f-65c541dd552c')
  end

  def to_json(phlo)
    {
        api_id: phlo.api_id,
        resource_uri: phlo.resource_uri,
        phlo_id: phlo.phlo_id,
        phlo_run_id: phlo.phlo_run_id
    }.to_json
  end

  it 'initiates a phlo' do
    contents = File.read(Dir.pwd + '/spec/mocks/phloRunResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@phlo.run())))
        .to eql(JSON.parse(contents))
    compare_requests(uri: '/Account/MAXXXXXXXXXXXXXXXXXX/Phlo/'\
                     'e564a84a-7910-4447-b16f-65c541dd552c/',
                     method: 'POST',
                     data: nil)


  end

end