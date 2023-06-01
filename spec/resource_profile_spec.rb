require 'rspec'

describe 'Profile test' do
    def to_json(obj)
        puts obj
        {
          api_id: obj.api_id,
          profile: obj.profile
        }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_profile(obj)
        {
        profile_uuid: obj['profile_uuid'],
        company_name: obj['company_name'],
        customer_type:obj['customer_type'],
        ein: obj['ein'],
        ein_issuing_country: obj['ein_issuing_country'],
        entity_type: obj['entity_type'],
        primary_profile: obj['primary_profile'],
        profile_alias: obj['profile_alias'],
        profile_type: obj['profile_type'],
        profile_uuid: obj['profile_uuid'],
        stock_exchange: obj['stock_exchange'],
        stock_symbol: obj['stock_symbol'],
        vertical: obj['vertical'],
        website: obj['website'],
        alt_business_id_type: obj['alt_business_id_type'],
        alt_business_id: obj['alt_business_id'],
        address: obj['address'],
        authorized_contact: obj['authorized_contact'],
        created_at: obj['created_at']
     }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_list(list_object)
        puts list_object
        objects_json = list_object['profiles'].map do |object|
            JSON.parse(to_json_profile(object))
          end
          {
            api_id: list_object['api_id'],
            profiles: objects_json
          }.to_json
    end
    def to_json_create(object)
        puts object
        {
            api_id: object.api_id,
            message: object.message,
            profile_uuid: object.profile_uuid
        }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_delete(object)
        puts object
        {
            api_id: object.api_id,
            message: object.message,
        }.reject { |_, v| v.nil? }.to_json
    end
    it 'get profile' do
        contents = File.read(Dir.pwd + '/spec/mocks/profileGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.profile
                       .get(
                         '201faedc-7df9-4840-9ab1-3997ce3f7cf4'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Profile/'\
                         '201faedc-7df9-4840-9ab1-3997ce3f7cf4/',
                         method: 'GET',
                         data: nil)
    end
    it 'list profile' do
        contents = File.read(Dir.pwd + '/spec/mocks/profileListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.profile
                                    .list({limit:2, offset:0}))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))    
          .to eql(contents) 
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Profile/',
                         method: 'GET',
                         data: {limit:2 , offset:0})
    end
    it 'delete profile' do
        contents = File.read(Dir.pwd + '/spec/mocks/profileDeleteResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.profile
                       .delete(
                         '201faedc-7df9-4840-9ab1-3997ce3f7cf4'
                       )
        expect(JSON.parse(to_json_delete(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Profile/'\
                         '201faedc-7df9-4840-9ab1-3997ce3f7cf4/',
                         method: 'DELETE',
                         data: nil)
    end
    it 'create profile' do
        contents = File.read(Dir.pwd + '/spec/mocks/profileCreateResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_create(@api.profile
                                    .create(
                                        params ={
                                            originator: "xxxxx", 
                                            profile_alias: "yyyyy",
                                            customer_type: "DIRECT",
                                            entity_type: "PRIVATE",
                                            company_name: "plivo",
                                            ein: "ghdwgdjwbdkjdw",
                                            ein_issuing_country: "US",
                                            stock_symbol: "jgasjdgja",
                                            stock_exchange: "AMEX",
                                            website: "www.example.com",
                                            vertical: "REAL_ESTATE",
                                            alt_business_id: "uyqgugdqw",
                                            alt_business_id_type: "jhjadada",
                                            plivo_subaccount: "123433566",
                                            address: {
                                                "street": "jhjhja",
                                                "city": "New York",
                                                "state": "Califernia",
                                                "postal_code": "6575",
                                                "country": "US"
                                            },
                                            authorized_contact: {
                                                "first_name": "john",
                                                "last_name": "con",
                                                "phone": "1876865565",
                                                "email": "xyz@plivo.com",
                                                "title": "ugigwc",
                                                "seniority": "jsgfjs"
                                            }
                                        }
                                    ))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Profile/',
                         method: 'POST',
                         data: {
                            originator: "xxxxx", 
                            profile_alias: "yyyyy",
                            customer_type: "DIRECT",
                            entity_type: "PRIVATE",
                            company_name: "plivo",
                            ein: "ghdwgdjwbdkjdw",
                            ein_issuing_country: "US",
                            stock_symbol: "jgasjdgja",
                            stock_exchange: "AMEX",
                            website: "www.example.com",
                            vertical: "REAL_ESTATE",
                            alt_business_id: "uyqgugdqw",
                            alt_business_id_type: "jhjadada",
                            plivo_subaccount: "123433566",
                            address: {
                                "street": "jhjhja",
                                "city": "New York",
                                "state": "Califernia",
                                "postal_code": "6575",
                                "country": "US"
                            },
                            authorized_contact: {
                                "first_name": "john",
                                "last_name": "con",
                                "phone": "1876865565",
                                "email": "xyz@plivo.com",
                                "title": "ugigwc",
                                "seniority": "jsgfjs"
                            }
                         })
        end
        it 'update profile' do
          contents = File.read(Dir.pwd + '/spec/mocks/profileUpdateResponse.json')
          mock(200, JSON.parse(contents))
          response = to_json(@api.profile
                                      .update('09322f43-fe16-4525-b8e4-4229c867795d', 
                                          params ={
                                              entity_type: "PRIVATE",
                                              company_name: "plivo",
                                              website: "www.example123.com",
                                              vertical: "REAL_ESTATE",
                                              address: {
                                                  "street": "1234",
                                                  "city": "New York",
                                                  "state": "Califernia",
                                                  "postal_code": "10001",
                                                  "country": "US"
                                              },
                                              authorized_contact: {
                                                  "first_name": "john",
                                                  "last_name": "con",
                                                  "phone": "1876865565",
                                                  "email": "xyz123@plivo.com",
                                                  "title": "ugigwc",
                                                  "seniority": "admin"
                                              }
                                          }
                                      ))
      
          contents = JSON.parse(contents)
      
          expect(JSON.parse(response))
            .to eql(contents)
          compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Profile/09322f43-fe16-4525-b8e4-4229c867795d/',
                           method: 'POST',
                           data: {
                            entity_type: "PRIVATE",
                            company_name: "plivo",
                            website: "www.example123.com",
                            vertical: "REAL_ESTATE",
                            address: {
                                "street": "1234",
                                "city": "New York",
                                "state": "Califernia",
                                "postal_code": "10001",
                                "country": "US"
                            },
                            authorized_contact: {
                                "first_name": "john",
                                "last_name": "con",
                                "phone": "1876865565",
                                "email": "xyz123@plivo.com",
                                "title": "ugigwc",
                                "seniority": "admin"
                            }
                           })
          end
end