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
     usecase: obj['usecase'],
     registration_status: obj['registration_status'],
     sub_usecase: obj['sub_usecase']
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
    def to_json_create(obj)
      puts obj
      {
        api_id: obj.api_id,
        campaign_id: obj.campaign_id,
        message: obj.message
      }.reject { |_, v| v.nil? }.to_json
  end
  def to_json_number_linkUnlink(obj)
    puts obj
    {
      api_id: obj.api_id,
      error: obj.error
    }.reject { |_, v| v.nil? }.to_json
  end
  def to_json_get_number(obj)
    puts obj
        {
          api_id: obj.api_id,
          campaign_alias: obj.campaign_alias,
          campaign_id: obj.campaign_id,
          phone_numbers: obj.phone_numbers,
          usecase: obj.usecase
        }.reject { |_, v| v.nil? }.to_json
  end
  def to_json_phone_numbers(obj)
    {
      number: obj['number'],
      status: obj['status']
    }.reject { |_, v| v.nil? }.to_json
  end
  def to_json_get_numbers(obj)
    puts obj
    objects_json = obj.phone_numbers.map do |object|
      JSON.parse(to_json_phone_numbers(object))
    end
    {
      api_id: obj.api_id,
      phone_numbers: objects_json,
      campaign_alias: obj.campaign_alias,
      campaign_id: obj.campaign_id,
      usecase: obj.usecase
    }.reject { |_, v| v.nil? }.to_json
  end
    it 'get campaign' do
        contents = File.read(Dir.pwd + '/spec/mocks/campaignGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.campaign
                       .get(
                         'CY5NVUA'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/'\
                         'CY5NVUA/',
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
        response = to_json_create(@api.campaign
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
                                description: "sample description text should be 40 character",
                                embedded_link: false,
                                embedded_phone: false,
                                age_gated: false,
                                direct_lending: false,
                                subscriber_optin: true,
                                subscriber_optout: true,
                                subscriber_help: true,
                                sample1: "sample message 1 should be 20 minimum character",
                                sample2: "sample message 2 should be 20 minimum character",
                                sample3: "test 3",
                                sample4: "test 4",
                                sample5: "test 5",
                                url: "http://example.com/test",
                                method: "POST",
                                subaccount_id: "109878667",
                                affiliate_marketing: false,
                                reseller_id: "98766",
                                message_flow: "message_flow should be minimum 40 character",
                                help_message: "hel_message should be minimum 20 character",
                                optout_message: "optoutmessage should be mandatory"
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
                                description: "sample description text should be 40 character",
                                embedded_link: false,
                                embedded_phone: false,
                                age_gated: false,
                                direct_lending: false,
                                subscriber_optin: true,
                                subscriber_optout: true,
                                subscriber_help: true,
                                sample1: "sample message 1 should be 20 minimum character",
                                sample2: "sample message 2 should be 20 minimum character",
                                sample3: "test 3",
                                sample4: "test 4",
                                sample5: "test 5",
                                url: "http://example.com/test",
                                method: "POST",
                                subaccount_id: "109878667",
                                affiliate_marketing: false,
                                reseller_id: "98766",
                                message_flow: "message_flow should be minimum 40 character",
                                help_message: "hel_message should be minimum 20 character",
                                optout_message: "optoutmessage should be mandatory"
                         })
    end
    it 'number_link campaign' do
      contents = File.read(Dir.pwd + '/spec/mocks/campaignNumberLinkUnlinkResponse.json')
      mock(200, JSON.parse(contents))
      response = to_json_number_linkUnlink(@api.campaign.number_link(
                                      options ={
                                        campaign_id:'BRPXS6E',
                                        url:'http://example.com/test',
                                        method:'POST',
                                        subaccount_id:'109878667',
                                        numbers: ['87654545465', '876650988']
                                    }
                                  ))
                                  
  
      contents = JSON.parse(contents)
  
      expect(JSON.parse(response))
        .to eql(contents)
      compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/BRPXS6E/Number/',
                       method: 'POST',
                       data: {
                        campaign_id:'BRPXS6E',
                        url:'http://example.com/test',
                        method:'POST',
                        subaccount_id:'109878667',
                        numbers: ['87654545465', '876650988']
                       })
  end
  it 'get_numbers campaign' do
    contents = File.read(Dir.pwd + '/spec/mocks/campaignNumbersGetResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_get_numbers(@api.campaign
                                    .get_numbers('CY5NVUA',
                                      options = {
                                        limit: 20,
                                        offset: 0
                                      }
                                    ))
    
    contents = JSON.parse(contents)
    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/CY5NVUA/Number/',
                      method: 'GET',
                      data: {
                        limit: 20,
                        offset: 0
                      })
  end
  it 'get_number campaign' do
    contents = File.read(Dir.pwd + '/spec/mocks/campaignNumberGetResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_get_number(@api.campaign
                                    .get_number('CY5NVUA', '98765433245'))
    
    contents = JSON.parse(contents)
    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/CY5NVUA/Number/98765433245/',
                      method: 'GET',
                      data: nil)
  end
  it 'number_unlink campaign' do
    contents = File.read(Dir.pwd + '/spec/mocks/campaignNumberLinkUnlinkResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_number_linkUnlink(@api.campaign.number_unlink('CY5NVUA', '98765433245'))
                                

    contents = JSON.parse(contents)

    expect(JSON.parse(response))
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/10dlc/Campaign/CY5NVUA/Number/98765433245/',
                     method: 'DELETE',
                     data: nil)
end
end