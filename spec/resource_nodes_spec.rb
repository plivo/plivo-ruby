require 'rspec'

describe 'node tests' do
  before :each do
    contents = File.read(Dir.pwd + '/spec/mocks/phloGetResponse.json')
    mock(200, JSON.parse(contents))
    @phlo = @phlo_client.phlo.get('e564a84a-7910-4447-b16f-65c541dd552c')
  end

  describe 'multi party call tests' do

    before :each do
      contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallGetResponse.json')
      mock(200, JSON.parse(contents))
      @multi_party_call = @phlo.multi_party_call('36989807-a76f-4555-84d1-9dfdccca7a80')
    end

    def to_json(node)
      {
          api_id: node.api_id,
          phlo_id: node.phlo_id,
          node_id: node.node_id,
          node_type: node.node_type,
          name: node.name,
      }.to_json
    end

    it 'agent makes outbound call to customer' do
      contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@multi_party_call.call('9090909090', '9090909090', 'customer'))))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/',
                       method: 'POST',
                       data: {:action=>"call", :trigger_source=>"+9090909090", :to=>"+9090909090", :role=>"customer"})


    end

    it 'agent initiates warm transfer' do
      contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@multi_party_call.warm_transfer('9090909090', '9090909090'))))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/',
                       method: 'POST',
                       data: {:action=>"warm_transfer", :trigger_source=>"+9090909090", :to=>"+9090909090", :role=>"agent"})

    end

    it 'agent initiates cold transfer' do
      contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@multi_party_call.cold_transfer('9090909090', '9090909090', 'customer'))))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/',
                       method: 'POST',
                       data: {:action=>"cold_transfer", :trigger_source=>"+9090909090", :to=>"+9090909090", :role=>"customer"})

    end

  end

  describe 'member tests: for multi party call node' do
    before do
      contents = File.read(Dir.pwd + '/spec/mocks/multiPartyCallGetResponse.json')
      mock(200, JSON.parse(contents))
      @multi_party_call = @phlo.multi_party_call('36989807-a76f-4555-84d1-9dfdccca7a80')
      @member = @multi_party_call.member('0000000000')
    end

    def to_json(member)
      {
          api_id: member.api_id,
          phlo_id: member.phlo_id,
          node_id: member.node_id,
          node_type: member.node_type,
          member_address: member.member_address
      }.to_json
    end

    it 'Agent places Customer on hold' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.hold)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"hold"})

    end

    it 'resume call after hold' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.unhold)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"unhold"})

    end

    it 'agent initiates Voicemail Drop' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.voicemail_drop)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"voicemail_drop"})

    end

    it 'Rejoin call on warm transfer' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.resume_call)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"resume_call"})

    end

    it 'Agent 1 leaves of the call ' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.hangup)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"hangup"})

    end

    it 'agent abort transfer' do
      contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
      mock(201, JSON.parse(contents))
      expect(JSON.parse(to_json(@member.abort_transfer)))
          .to eql(JSON.parse(contents))
      compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/+0000000000/',
                       method: 'POST',
                       data: {:action=>"abort_transfer"})

    end

    # it 'Remove a member from the Multi-Party Call' do
    #   contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
    #   mock(204, JSON.parse(contents))
    #   expect(JSON.parse(to_json(@member.remove)))
    #       .to eql(JSON.parse(contents))
    #   compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/multi_party_call/36989807-a76f-4555-84d1-9dfdccca7a80/members/0000000000/',
    #                    method: 'DELETE',
    #                    data: nil)
    #
    # end

  end

  # describe 'member tests: for conference bridge node' do
  #   before :each do
  #     contents = File.read(Dir.pwd + '/spec/mocks/conferenceBridgeGetResponse.json')
  #     mock(200, JSON.parse(contents))
  #     @conference_bridge = @phlo.conference_bridge('36989807-a76f-4555-84d1-9dfdccca7a80')
  #     @member = @conference_bridge.member('0000000000')
  #   end
  #
  #   def to_json(member)
  #     {
  #         api_id: member.api_id,
  #         phlo_id: member.phlo_id,
  #         node_id: member.node_id,
  #         node_type: member.node_type,
  #         member_address: member.member_address
  #     }.to_json
  #   end
  #
  #   describe 'update a member in the conference bridge' do
  #     it 'mutes the member' do
  #       contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
  #       mock(201, JSON.parse(contents))
  #       expect(JSON.parse(to_json(@member.mute)))
  #           .to eql(JSON.parse(contents))
  #       compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/conference_bridge/36989807-a76f-4555-84d1-9dfdccca7a80/members/0000000000/',
  #                        method: 'POST',
  #                        data: {:action=>"mute"})
  #
  #     end
  #
  #     it 'unmutes the member' do
  #       contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
  #       mock(201, JSON.parse(contents))
  #       expect(JSON.parse(to_json(@member.unmute)))
  #           .to eql(JSON.parse(contents))
  #       compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/conference_bridge/36989807-a76f-4555-84d1-9dfdccca7a80/members/0000000000/',
  #                        method: 'POST',
  #                        data: {:action=>"unmute"})
  #
  #     end
  #
  #     it 'member leaves the call' do
  #       contents = File.read(Dir.pwd + '/spec/mocks/memberActionResponse.json')
  #       mock(201, JSON.parse(contents))
  #       expect(JSON.parse(to_json(@member.hangup)))
  #           .to eql(JSON.parse(contents))
  #       compare_requests(uri: '/v1/phlo/e564a84a-7910-4447-b16f-65c541dd552c/conference_bridge/36989807-a76f-4555-84d1-9dfdccca7a80/members/0000000000/',
  #                        method: 'POST',
  #                        data: {:action=>"hangup"})
  #
  #     end
  #   end
  # end
end
