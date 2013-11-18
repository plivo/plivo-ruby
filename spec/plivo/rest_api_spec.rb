require 'spec_helper'

describe Plivo::RestAPI, '#request' do
  context 'when passed a path with no trailing slash' do
    it 'appends a trailing slash' do
      Plivo::RestAPI.client.rest.expects(:get).with("/v1/Account/AUTH_ID/Endpoint/")
      Plivo::RestAPI.client.request('GET', "/v1/Account/AUTH_ID/Endpoint")
    end
  end

  context 'when passed a path with a trailing slash' do
    it 'does not add another slash' do
      Plivo::RestAPI.client.rest.expects(:get).with("/v1/Account/AUTH_ID/Endpoint/")
      Plivo::RestAPI.client.request('GET', "/v1/Account/AUTH_ID/Endpoint/")
    end
  end
end
