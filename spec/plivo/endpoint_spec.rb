require 'spec_helper'

describe Plivo::Endpoint, '.create' do
  context 'when successfully creating an endpoint', :vcr do
    it 'returns an Endpoint object with the properties' do
      endpoint = Plivo::Endpoint.create(
        'username' => 'test123',
        'password' => 'password342',
        'alias'    => 'testendpoint')

      endpoint.should be_a(Plivo::Endpoint)
      endpoint.endpoint_id.should_not be_nil
    end
  end
end