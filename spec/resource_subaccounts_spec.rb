require 'rspec'
require 'json'
require 'spec_helper'

describe 'Subaccounts test' do
  def to_json(subaccount)
    {
      account: subaccount.account,
      api_id: subaccount.api_id,
      auth_id: subaccount.auth_id,
      auth_token: subaccount.auth_token,
      new_auth_token: subaccount.new_auth_token,
      created: subaccount.created,
      enabled: subaccount.enabled,
      modified: subaccount.modified,
      name: subaccount.name,
      resource_uri: subaccount.resource_uri
    }.to_json
  end

  def to_json_update(subaccount)
    {
      api_id: subaccount.api_id,
      message: subaccount.message
    }.to_json
  end

  def to_json_create(subaccount)
    {
      api_id: subaccount.api_id,
      message: subaccount.message,
      auth_id: subaccount.auth_id,
      auth_token: subaccount.auth_token
    }.to_json
  end

  def to_json_list(list_object)
    objects_json = list_object[:objects].map do |object|
      obj = JSON.parse(to_json(object))
      obj.delete('api_id')
      obj
    end
    {
      api_id: list_object[:api_id],
      meta: list_object[:meta],
      objects: objects_json
    }.to_json
  end

  it 'creates a subaccount' do
    contents = File.read(Dir.pwd + '/spec/mocks/subaccountCreateResponse.json')
    mock(201, JSON.parse(contents))
    expect(JSON.parse(to_json_create(@api.subaccounts.create('test_name')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Subaccount/',
                     method: 'POST',
                     data: {
                       name: 'test_name',
                       enabled: false
                     })
  end

  it 'fetches details of a subaccount' do
    contents = File.read(Dir.pwd + '/spec/mocks/subaccountGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.subaccounts.get('SAXXXXXXXXXXXXXXXXXX')))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Subaccount/'\
                     'SAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'lists all subaccounts' do
    contents = File.read(Dir.pwd + '/spec/mocks/subaccountListResponse.json')
    mock(200, JSON.parse(contents))
    response = to_json_list(@api.subaccounts
                                .list(
                                  offset: 4
                                ))
    expect(JSON.parse(response)).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Subaccount/',
                     method: 'GET',
                     data: {
                       offset: 4
                     })
  end

  it 'updates the subaccount' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = File.read(Dir.pwd + '/spec/mocks/subaccountModifyResponse.json')
    mock(202, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.subaccounts.update(id,
                                                             'test name',
                                                             true))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Subaccount/' + id + '/',
                     method: 'POST',
                     data: {
                       name: 'test name',
                       enabled: true
                     })
  end

  it 'deletes the subaccount' do
    id = 'SAXXXXXXXXXXXXXXXXXX'
    contents = '{}'
    mock(204, JSON.parse(contents))
    @api.subaccounts.delete(id)
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Subaccount/' + id + '/',
                     method: 'DELETE',
                     data: nil)
  end
end
