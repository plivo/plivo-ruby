require 'rspec'
require 'json'

describe 'PhoneNumber Compliance Requirements test' do
  def to_json_requirement(obj)
    {
      api_id: obj.api_id,
      requirement_id: obj.requirement_id,
      country_iso: obj.country_iso,
      number_type: obj.number_type,
      user_type: obj.user_type,
      document_types: obj.document_types
    }.reject { |_, v| v.nil? }.to_json
  end

  it 'gets compliance requirements' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceRequirementGetResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.phone_number_compliance_requirements.get(
      country_iso: 'IN',
      number_type: 'local',
      user_type: 'business'
    )
    expect(JSON.parse(to_json_requirement(response)))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/Requirements/',
                     method: 'GET',
                     data: {
                       country_iso: 'IN',
                       number_type: 'local',
                       user_type: 'business'
                     })
  end

  it 'gets requirements with empty document_types' do
    contents = {
      'api_id' => 'test-id',
      'requirement_id' => 'req-789',
      'country_iso' => 'US',
      'number_type' => 'tollfree',
      'user_type' => 'business',
      'document_types' => []
    }
    mock(200, contents)
    response = @api.phone_number_compliance_requirements.get(
      country_iso: 'US',
      number_type: 'tollfree',
      user_type: 'business'
    )
    expect(response.document_types).to eql([])
    expect(response.country_iso).to eql('US')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/Requirements/',
                     method: 'GET',
                     data: {
                       country_iso: 'US',
                       number_type: 'tollfree',
                       user_type: 'business'
                     })
  end

  it 'verifies the requirements URL path' do
    contents = {
      'api_id' => 'test-id',
      'requirement_id' => 'req-456',
      'document_types' => []
    }
    mock(200, contents)
    @api.phone_number_compliance_requirements.get(
      country_iso: 'US'
    )
    expect($request[:uri]).to include('/PhoneNumber/Compliance/Requirements/')
    expect($request[:method]).to eql('GET')
  end
end

describe 'PhoneNumber Compliance test' do
  def to_json_compliance(obj)
    {
      api_id: obj.api_id,
      compliance_id: obj.compliance_id,
      alias: obj.alias,
      status: obj.status,
      country_iso: obj.country_iso,
      number_type: obj.number_type,
      user_type: obj.user_type,
      callback_url: obj.callback_url,
      callback_method: obj.callback_method,
      created_at: obj.created_at,
      updated_at: obj.updated_at
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_create(obj)
    {
      api_id: obj.api_id,
      compliance_id: obj.compliance_id,
      message: obj.message
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_list_object(obj)
    {
      compliance_id: obj.compliance_id,
      alias: obj.alias,
      status: obj.status,
      country_iso: obj.country_iso,
      number_type: obj.number_type,
      user_type: obj.user_type,
      created_at: obj.created_at,
      updated_at: obj.updated_at
    }.reject { |_, v| v.nil? }.to_json
  end

  def to_json_list(list_object)
    objects_json = list_object[:objects].map do |object|
      JSON.parse(to_json_list_object(object))
    end
    {
      api_id: list_object[:api_id],
      meta: list_object[:meta],
      objects: objects_json
    }.to_json
  end

  # ── Create ──────────────────────────────────────────────────────────────────

  it 'creates a compliance application' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceCreateResponse.json')
    mock(200, JSON.parse(contents))
    data_hash = {
      country_iso: 'IN',
      number_type: 'local',
      user_type: 'business',
      alias: 'TestBiz',
      end_user: { name: 'Test User' }
    }
    response = @api.phone_number_compliances.create(data_hash)
    expect(JSON.parse(to_json_create(response)))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'POST',
                     data: { data: JSON.generate(data_hash) })
  end

  it 'creates a compliance application with multipart data' do
    contents = {
      'api_id' => 'test-id',
      'compliance_id' => 'comp-def456',
      'message' => 'created'
    }
    mock(200, contents)
    data_hash = {
      country_iso: 'GB',
      number_type: 'mobile',
      alias: 'UK Mobile',
      end_user: { name: 'Jane Doe' },
      callback_url: 'https://example.com/callback',
      callback_method: 'POST'
    }
    response = @api.phone_number_compliances.create(data_hash)
    expect(response.compliance_id).to eql('comp-def456')
    expect(response.message).to eql('created')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'POST',
                     data: { data: JSON.generate(data_hash) })
  end

  # ── List ────────────────────────────────────────────────────────────────────

  it 'lists compliance applications' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.phone_number_compliances.list)

    contents = JSON.parse(contents)
    objects = contents['objects'].map do |obj|
      obj.reject { |_, v| v.nil? }
    end
    contents['objects'] = objects

    expect(JSON.parse(response).reject { |_, v| v.nil? })
      .to eql(contents)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists compliance applications with filters' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceListResponse.json')
    mock(200, JSON.parse(contents))
    @api.phone_number_compliances.list(
      status: 'submitted',
      country_iso: 'IN',
      number_type: 'local',
      user_type: 'business',
      limit: 5,
      offset: 0
    )
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'GET',
                     data: {
                       status: 'submitted',
                       country_iso: 'IN',
                       number_type: 'local',
                       user_type: 'business',
                       limit: 5,
                       offset: 0
                     })
  end

  it 'lists compliance applications with empty results' do
    contents = {
      'api_id' => 'test-id',
      'meta' => {
        'limit' => 20,
        'offset' => 0,
        'total_count' => 0,
        'next' => nil,
        'previous' => nil
      },
      'objects' => []
    }
    mock(200, contents)
    response = @api.phone_number_compliances.list
    expect(response[:meta]['total_count']).to eql(0)
    expect(response[:objects]).to eql([])
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists with pagination meta' do
    contents = {
      'api_id' => 'test-id',
      'meta' => {
        'limit' => 5,
        'offset' => 10,
        'total_count' => 25,
        'next' => '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/?limit=5&offset=15',
        'previous' => '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/?limit=5&offset=5'
      },
      'objects' => [
        { 'compliance_id' => 'comp_010', 'status' => 'approved' },
        { 'compliance_id' => 'comp_011', 'status' => 'pending' }
      ]
    }
    mock(200, contents)
    response = @api.phone_number_compliances.list(limit: 5, offset: 10)
    expect(response[:meta]['limit']).to eql(5)
    expect(response[:meta]['offset']).to eql(10)
    expect(response[:meta]['total_count']).to eql(25)
    expect(response[:meta]['next']).not_to be_nil
    expect(response[:meta]['previous']).not_to be_nil
    expect(response[:objects].length).to eql(2)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/',
                     method: 'GET',
                     data: { limit: 5, offset: 10 })
  end

  # ── Get ─────────────────────────────────────────────────────────────────────

  it 'fetches details of a compliance application' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceGetResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.phone_number_compliances.get('767bc62c-2332-4a34-959c-1f6416186254')
    expect(JSON.parse(to_json_compliance(response)))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/' \
                     '767bc62c-2332-4a34-959c-1f6416186254/',
                     method: 'GET',
                     data: {})
  end

  it 'fetches a compliance application with expand parameter' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceGetResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.phone_number_compliances.get(
      '767bc62c-2332-4a34-959c-1f6416186254',
      expand: 'end_user,documents,linked_numbers'
    )
    expect(response.compliance_id).to eql('767bc62c-2332-4a34-959c-1f6416186254')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/' \
                     '767bc62c-2332-4a34-959c-1f6416186254/',
                     method: 'GET',
                     data: { expand: 'end_user,documents,linked_numbers' })
  end

  it 'fetches a compliance application with all optional fields' do
    contents = {
      'api_id' => 'test-id',
      'compliance_id' => 'test-comp-id',
      'alias' => 'test',
      'status' => 'rejected',
      'country_iso' => 'IN',
      'number_type' => 'local',
      'user_type' => 'business',
      'rejection_reason' => 'Invalid documents',
      'callback_url' => 'https://example.com',
      'callback_method' => 'GET',
      'created_at' => '2026-04-06T10:44:17Z',
      'updated_at' => '2026-04-06T10:44:17Z',
      'end_user' => {
        'end_user_id' => 'eu-123',
        'type' => 'business',
        'name' => 'TestCorp'
      },
      'documents' => [
        {
          'document_id' => 'doc-123',
          'document_type_id' => 'dt-123',
          'document_name' => 'Registration Certificate'
        }
      ],
      'linked_numbers' => [
        { 'number' => '+911234567890', 'number_type' => 'local' }
      ]
    }
    mock(200, contents)
    response = @api.phone_number_compliances.get(
      'test-comp-id',
      expand: 'end_user,documents,linked_numbers'
    )
    expect(response.status).to eql('rejected')
    expect(response.rejection_reason).to eql('Invalid documents')
    expect(response.end_user['end_user_id']).to eql('eu-123')
    expect(response.documents.length).to eql(1)
    expect(response.documents[0]['document_id']).to eql('doc-123')
    expect(response.linked_numbers.length).to eql(1)
    expect(response.linked_numbers[0]['number']).to eql('+911234567890')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/' \
                     'test-comp-id/',
                     method: 'GET',
                     data: { expand: 'end_user,documents,linked_numbers' })
  end

  it 'returns error for non-existent compliance application' do
    mock(404, { 'error' => 'Compliance application not found.' })
    expect do
      @api.phone_number_compliances.get('nonexistent-id')
    end.to raise_error(Plivo::Exceptions::PlivoRESTError)
  end

  # ── Update ──────────────────────────────────────────────────────────────────

  it 'updates a compliance application' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceUpdateResponse.json')
    mock(200, JSON.parse(contents))
    data_hash = { alias: 'patched-alias-2084' }
    response = @api.phone_number_compliances.update(
      'f812efe4-a461-4f00-b6ae-bdfb40fcc343',
      data_hash
    )
    expect(response.message).to eql('Compliance application updated and resubmitted for review.')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/' \
                     'f812efe4-a461-4f00-b6ae-bdfb40fcc343/',
                     method: 'PATCH',
                     data: { data: JSON.generate(data_hash) })
  end

  it 'verifies update uses PATCH method' do
    contents = {
      'api_id' => 'test-id',
      'message' => 'updated',
      'compliance_id' => 'comp-xyz789',
      'status' => 'pending'
    }
    mock(200, contents)
    data_hash = { end_user: { name: 'New Name' } }
    @api.phone_number_compliances.update('comp-xyz789', data_hash)
    expect($request[:method]).to eql('PATCH')
  end

  # ── Delete ──────────────────────────────────────────────────────────────────

  it 'deletes a compliance application' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceDeleteResponse.json')
    mock(200, JSON.parse(contents))
    response = @api.phone_number_compliances.delete('d73b0188-08a8-4bb0-8acf-25e23e274120')
    expect(response.message).to eql('Compliance application deleted.')
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/' \
                     'd73b0188-08a8-4bb0-8acf-25e23e274120/',
                     method: 'DELETE',
                     data: nil)
  end

  it 'returns error when deleting non-existent compliance application' do
    mock(404, { 'error' => 'Compliance application not found.' })
    expect do
      @api.phone_number_compliances.delete('nonexistent-id')
    end.to raise_error(Plivo::Exceptions::PlivoRESTError)
  end
end

describe 'PhoneNumber Compliance Link test' do
  def to_json_link(obj)
    {
      api_id: obj.api_id,
      total_count: obj.total_count,
      updated_count: obj.updated_count,
      report: obj.report
    }.reject { |_, v| v.nil? }.to_json
  end

  it 'links numbers to compliance applications' do
    contents = File.read(Dir.pwd + '/spec/mocks/phoneNumberComplianceLinkResponse.json')
    mock(200, JSON.parse(contents))
    numbers = [
      { number: '+912248885512', compliance_application_id: '074d687f-5630-483d-8349-5b9d7686d673' },
      { number: '+912248885513', compliance_application_id: '074d687f-5630-483d-8349-5b9d7686d673' }
    ]
    response = @api.phone_number_compliance_link.create(numbers)
    expect(JSON.parse(to_json_link(response)))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/Link/',
                     method: 'POST',
                     data: { numbers: numbers })
  end

  it 'links numbers with empty report' do
    contents = {
      'api_id' => 'test-id',
      'total_count' => 0,
      'updated_count' => 0,
      'report' => []
    }
    mock(200, contents)
    response = @api.phone_number_compliance_link.create([])
    expect(response.total_count).to eql(0)
    expect(response.updated_count).to eql(0)
    expect(response.report).to eql([])
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/Link/',
                     method: 'POST',
                     data: { numbers: [] })
  end

  it 'verifies link URL path' do
    contents = {
      'api_id' => 'test-id',
      'report' => [
        { 'number' => '+441234567890', 'status' => 'success' }
      ]
    }
    mock(200, contents)
    numbers = [
      { number: '+441234567890', compliance_application_id: 'comp-uk001' }
    ]
    @api.phone_number_compliance_link.create(numbers)
    expect($request[:uri]).to eql('/v1/Account/MAXXXXXXXXXXXXXXXXXX/PhoneNumber/Compliance/Link/')
    expect($request[:method]).to eql('POST')
  end
end
