require 'rspec'

describe 'Brand test' do
    def to_json(obj)
        puts obj
        {
          api_id: obj.api_id,
          brand: obj.brand
        }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_brand(obj)
     {
     brand_id: obj['brand_id'],
     company_name: obj['company_name'],
     ein:obj['ein'],
     ein_issuing_country: obj['ein_issuing_country'],
     email: obj['email'],
     entity_type: obj['entity_type'],
     registration_status: obj['registration_status'],
     vertical: obj['vertical'],
     website: obj['website']
     }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_list(list_object)
        puts list_object
        objects_json = list_object['brands'].map do |object|
            JSON.parse(to_json_brand(object))
          end
          {
            api_id: list_object['api_id'],
            brands: objects_json
          }.to_json
    end
    it 'get brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.brand
                       .get(
                         'BRPXS6E'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/'\
                         'BRPXS6E/',
                         method: 'GET',
                         data: nil)
    end
    it 'list brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.brand
                                    .list())

        contents = JSON.parse(contents)

        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/',
                         method: 'GET',
                         data: nil)
    end
    it 'create brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandCreateResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json(@api.brand
                                    .create(
                                        params ={alt_business_id_type: "GIIN",
                                        alt_business_id: "111",
                                        brand_id: "B9UGPAG",
                                        city: "New York",
                                        company_name: "ABC Inc.",
                                        country: "US",
                                        ein: "111111111",
                                        ein_issuing_country: "US",
                                        email: "johndoe@abc.com",
                                        entity_type: "SOLE_PROPRIETOR",
                                        first_name: "John",
                                        last_name: "Doe",
                                        phone: "+11234567890",
                                        postal_code: "10001",
                                        registration_status: "PENDING",
                                        state: "NY",
                                        stock_exchange: "NASDAQ",
                                        stock_symbol: "ABC",
                                        street: "123",
                                        vertical: "RETAIL",
                                        website: "http://www.abcmobile.com",
                                        referenceId: 11}
                                    ))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/',
                         method: 'POST',
                         data: {
                            alt_business_id_type: "GIIN",
                            alt_business_id: "111",
                            brand_id: "B9UGPAG",
                            city: "New York",
                            company_name: "ABC Inc.",
                            country: "US",
                            ein: "111111111",
                            ein_issuing_country: "US",
                            email: "johndoe@abc.com",
                            entity_type: "SOLE_PROPRIETOR",
                            first_name: "John",
                            last_name: "Doe",
                            phone: "+11234567890",
                            postal_code: "10001",
                            registration_status: "PENDING",
                            state: "NY",
                            stock_exchange: "NASDAQ",
                            stock_symbol: "ABC",
                            street: "123",
                            vertical: "RETAIL",
                            website: "http://www.abcmobile.com",
                            referenceId: 11
                         })
    end
end