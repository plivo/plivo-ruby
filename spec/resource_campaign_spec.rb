require 'rspec'

describe 'Campaign test' do
    def to_json(obj)
        puts obj
        {
          api_id: obj.api_id,
          campaign: obj.campaign
        }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_campaign(obj)
     {
     brand_id: obj['brand_id'],
     campaign_id: obj['campaign_id'],
     mno_metadata:obj['mno_metadata'],
     reseller_id: obj['reseller_id'],
     usecase: obj['usecase']
     }.reject { |_, v| v.nil? }.to_json
    end
    def to_json_list(list_object)
        puts list_object
        objects_json = list_object['campaigns'].map do |object|
            JSON.parse(to_json_campaign(object))
          end
          {
            api_id: list_object['api_id'],
            campaigns: objects_json
          }.to_json
    end
    it 'get campaign' do
        contents = File.read(Dir.pwd + '/spec/mocks/campaignGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.campaign
                       .get(
                         'CMPT4EP'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/'\
                         'CMPT4EP/',
                         method: 'GET',
                         data: nil)
    end
    it 'list campaign' do
        contents = File.read(Dir.pwd + '/spec/mocks/campaignListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.campaign
                                    .list())
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/',
                         method: 'GET',
                         data: nil)
    end
    it 'create campaign' do
        contents = File.read(Dir.pwd + '/spec/mocks/campaignCreateResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json(@api.campaign
                                    .create(
                                        params ={
                                brand_id: "B8OD95Z",
                                campaign_alias: "campaign name sssample",
                                vertical: "INSURANCE",
                                usecase: "MIXED",
                                sub_usecases: [
                                    "CUSTOMER_CARE",
                                    "2FA"
                                ],
                                description: "sample description text",
                                embedded_link: false,
                                embedded_phone: false,
                                age_gated: false,
                                direct_lending: false,
                                subscriber_optin: true,
                                subscriber_optout: true,
                                subscriber_help: true,
                                sample1: "test 1",
                                sample2: "test 2"
                                }
                                    ))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/',
                         method: 'POST',
                         data: {
                            brand_id: "B8OD95Z",
                            campaign_alias: "campaign name sssample",
                                vertical: "INSURANCE",
                                usecase: "MIXED",
                                sub_usecases: [
                                    "CUSTOMER_CARE",
                                    "2FA"
                                ],
                                description: "sample description text",
                                embedded_link: false,
                                embedded_phone: false,
                                age_gated: false,
                                direct_lending: false,
                                subscriber_optin: true,
                                subscriber_optout: true,
                                subscriber_help: true,
                                sample1: "test 1",
                                sample2: "test 2"
                         })
    end
end