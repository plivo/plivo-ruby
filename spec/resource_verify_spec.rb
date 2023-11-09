require 'rspec'

describe 'Sessions test' do
    def to_json(verify_session)
        {
            api_id: verify_session.api_id,
            session_uuid: verify_session.session_uuid,
            app_uuid: verify_session.app_uuid,
            alias: verify_session.alias,
            recipient: verify_session.recipient,
            channel: verify_session.channel,
            status: verify_session.status,
            count: verify_session.count,
            requestor_ip: verify_session.requestor_ip,
            destination_country_iso2: verify_session.destination_country_iso2,
            destination_network: verify_session.destination_network,
            attempt_details: verify_session.attempt_details,
            charges: verify_session.charges,
            created_at: verify_session.created_at,
            updated_at: verify_session.updated_at
        }.to_json
    end

    def to_json_create(session)
        {
        message: session.message,
        session_uuid: session.session_uuid,
        api_id: session.api_id
        }.to_json
    end

    def to_json_sessions(verify_session)
        {
            session_uuid: verify_session['session_uuid'],
            app_uuid: verify_session['app_uuid'],
            alias: verify_session['alias'],
            recipient: verify_session['recipient'],
            channel: verify_session['channel'],
            status: verify_session['status'],
            count: verify_session['count'],
            requestor_ip: verify_session['requestor_ip'],
            destination_country_iso2: verify_session['destination_country_iso2'],
            destination_network: verify_session['destination_network'],
            attempt_details: verify_session['attempt_details'],
            charges: verify_session['charges'],
            created_at: verify_session['created_at'],
            updated_at: verify_session['updated_at']
        }.to_json
    end

    def to_json_list(list_object)
        objects_json = list_object['sessions'].map do |object|
            JSON.parse(to_json_sessions(object))
          end
        {
        api_id: list_object['api_id'],
        meta: list_object['meta'],
        sessions: objects_json
        }.to_json
    end


    it 'fetches details of a sessions' do
        contents = File.read(Dir.pwd + '/spec/mocks/sessionGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.verify_session
                    .get(
                        'SAXXXXXXXXXXXXXXXXXX'
                    )             
        expect(JSON.parse(to_json(response)))
        .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verify/Session/'\
                        'SAXXXXXXXXXXXXXXXXXX/',
                        method: 'GET',
                        data: nil)
        expect(response.id).to eql(response.session_uuid)
        expect(response.requestor_ip).to eql("122.163.227.219")
    end

    it 'lists all sessions' do
        contents = File.read(Dir.pwd + '/spec/mocks/sessionListResponse.json')
        mock(200, JSON.parse(contents))       
        response = to_json_list(@api.verify_session
                                    .list(
                                    subaccount: 'SAXXXXXXXXXXXXXXXXX'
                                    ))

        contents = JSON.parse(contents)

        expect(JSON.parse(response))
        .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verify/Session/',
                        method: 'GET',
                        data: {
                        subaccount: 'SAXXXXXXXXXXXXXXXXX',
                        })
    end

 
    it 'sends a session' do
        contents = File.read(Dir.pwd + '/spec/mocks/sessionSendResponse.json')
        mock(201, JSON.parse(contents))
        expect(JSON.parse(to_json_create(@api.verify_session
                                            .create(nil,
                                            '1234567890',nil,nil,nil
                                            ))))
        .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verify/Session/',
                        method: 'POST',
                        data: {
                        app_uuid: nil,    
                        recipient: '1234567890',
                        channel: nil,
                        url: nil,
                        method: nil
                        })
    end

    it 'validate a session' do
        contents = File.read(Dir.pwd + '/spec/mocks/sessionSendResponse.json')
        mock(201, JSON.parse(contents))
        expect(JSON.parse(to_json_create(@api.verify_session
                                            .validate(
                                           '12345-6789-0000',
                                            '123456'
                                            ))))
        .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Verify/Session/12345-6789-0000/',
                        method: 'POST',
                        data: {
                            otp: '123456'
                        })
    end
end  