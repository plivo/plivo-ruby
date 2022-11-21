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
     address: obj['address'],
     authorized_contact: obj['authorized_contact'],
     brand_id: obj['brand_id'],
     brand_type: obj['brand_type'],
     ein_issuing_country:obj['ein_issuing_country'],
     registration_status: obj['registration_status'],
     brand_alias: obj['brand_alias'],
     profile_uuid: obj['profile_uuid'],
     vertical: obj['vertical'],
     vetting_score: obj['vetting_score'],
     vetting_status: obj['vetting_status'],
     entity_type: obj['entity_type'],
     ein: obj['ein'],
     website: obj['website'],
     company_name: obj['company_name']

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
    def to_json_create(obj)
      puts obj
      {
        api_id: obj.api_id,
        brand_id: obj.brand_id,
        message: obj.message
      }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_brand_usecase(obj)
      puts obj
      {
        api_id: obj.api_id,
        brand_id: obj.brand_id,
        use_cases: obj.use_cases
      }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_delete(obj)
      puts obj
      {
        api_id: obj.api_id,
        brand_id: obj.brand_id,
        message: obj.message
      }.reject { |_, v| v.nil? }.to_json
    end
    it 'get brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.brand
                       .get(
                         'BPL3KN9'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/'\
                         'BPL3KN9/',
                         method: 'GET',
                         data: nil)
    end
    it 'list brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.brand
                                    .list({status: "COMPLETED", limit:2, offset:0}))

        contents = JSON.parse(contents)

        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/',
                         method: 'GET',
                         data: {status: "COMPLETED", limit:2, offset:0})
    end
    it 'create brand' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandCreateResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_create(@api.brand
                                    .create(
                                        params ={
                                          brand_alias: "brand name sample",
                                          brand_type: "STARTER",
                                          profile_uuid: "201faedc-7df9-4840-9ab1-3997ce3f7cf4",
                                          secondary_vetting: false,
                                          url: "http://example.come/test",
                                          method: "POST",
                                          subaccount_id: "1234544",
                                          emailRecipients: "mrm",
                                          campaignName: "plivo",
                                          campaignUseCase: "MIXED",
                                          campaignSubUseCases: ["2FA"],
                                          campaignDescription: "MIXED campaign",
                                          sampleMessage1: "sample1",
                                          sampleMessage2: "sample2",
                                          embeddedLink: false,
                                          embeddedPhone: false,
                                          numberPool: false,
                                          ageGated: false,
                                          directLending: false,
                                          subscriberOptin: false,
                                          subscriberOptout: false,
                                          subscriberHelp: false,
                                          affiliateMarketing: false,
                                          resellerID: "87868787788"
                                        }
                                    ))

        contents = JSON.parse(contents)

        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/',
                         method: 'POST',
                         data: {
                          brand_alias: "brand name sample",
                          brand_type: "STARTER",
                          profile_uuid: "201faedc-7df9-4840-9ab1-3997ce3f7cf4",
                          secondary_vetting: false,
                          url: "http://example.come/test",
                          method: "POST",
                          subaccount_id: "1234544",
                          emailRecipients: "mrm",
                          campaignName: "plivo",
                          campaignUseCase: "MIXED",
                          campaignSubUseCases: ["2FA"],
                          campaignDescription: "MIXED campaign",
                          sampleMessage1: "sample1",
                          sampleMessage2: "sample2",
                          embeddedLink: false,
                          embeddedPhone: false,
                          numberPool: false,
                          ageGated: false,
                          directLending: false,
                          subscriberOptin: false,
                          subscriberOptout: false,
                          subscriberHelp: false,
                          affiliateMarketing: false,
                          resellerID: "87868787788"
                         })
    end
    it 'get brand usecase' do
        contents = File.read(Dir.pwd + '/spec/mocks/brandGetUsecasesResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.brand
                       .get_usecases(
                         'BPL3KN9'
                       )
        expect(JSON.parse(to_json_brand_usecase(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/'\
                         'BPL3KN9/usecases/',
                         method: 'GET',
                         data: nil)
    end
    it 'delete brand' do
      contents = File.read(Dir.pwd + '/spec/mocks/brandDeleteResponse.json')
      mock(200, JSON.parse(contents))
      response = @api.brand
                     .delete(
                       'BPL3KN9'
                     )
      expect(JSON.parse(to_json_delete(response)))
        .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Brand/'\
                       'BPL3KN9/',
                       method: 'Delete',
                       data: nil)
    end
    
end
