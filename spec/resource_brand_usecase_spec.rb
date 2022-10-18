require 'rspec'

describe 'BrandUsecase test' do
    def to_json(obj)
        puts obj
        {
          api_id: obj.api_id,
          brand_id: obj.brand_id,
          use_cases: obj.use_cases
        }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_brand(obj)
     {
     brand_id: obj['brand_id'],
     use_cases: obj['usecases']
     }.reject { |_, v| v.nil? }.to_json
    end
    
    it 'get brand usecase' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandGetUsecasesResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.brand_usecases
                       .get(
                         'BPL3KN9'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/'\
                         'BPL3KN9/usecases',
                         method: 'GET',
                         data: nil)
    end
    
end