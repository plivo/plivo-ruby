require 'rspec'
require 'json'
require 'spec_helper'

describe 'Accounts test' do
  def to_json(account)
    {
      account_type: account.account_type,
      address: account.address,
      api_id: account.api_id,
      auth_id: account.auth_id,
      auto_recharge: account.auto_recharge,
      billing_mode: account.billing_mode,
      cash_credits: account.cash_credits,
      city: account.city,
      name: account.name,
      resource_uri: account.resource_uri,
      state: account.state,
      timezone: account.timezone
    }.to_json
  end

  def to_json_update(account)
    {
      api_id: account.api_id,
      message: account.message
    }.to_json
  end

  it 'fetches details of the account' do
    contents = File.read(Dir.pwd + '/spec/mocks/accountGetResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json(@api.account.details))).to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/',
                     method: 'GET',
                     data: nil)
  end

  it 'updates the account' do
    contents = File.read(Dir.pwd + '/spec/mocks/accountModifyResponse.json')
    mock(200, JSON.parse(contents))
    expect(JSON.parse(to_json_update(@api.account
                                         .update(
                                           name: 'haha',
                                           city: 'city',
                                           address: 'address'
                                         ))))
      .to eql(JSON.parse(contents))
    compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/',
                     method: 'POST',
                     data: {
                       name: 'haha',
                       city: 'city',
                       address: 'address'
                     })
  end
end
