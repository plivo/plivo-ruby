require 'spec_helper'

describe Plivo::SMS, '.create', :vcr do
  def create_message
    Plivo::SMS.create(
      src: @rented.number,
      dst: '111-222-3344',
      text: 'Test message'
    )
  end

  before do
    @rented = Plivo::AvailableNumberGroup.search(country_iso: 'US', services: 'sms').first.rent
    @rented = Plivo::RentedNumber.find(@rented['numbers'].first['number'])
  end

  it 'hits the api' do
    client = Plivo::RestAPI.client
    client.expects(:request).with("POST", "Message/", {
      src: @rented.number,
      dst: '111-222-3344',
      text: 'Test message'
    })
    create_message
  end

  it 'queues a message to be sent' do
    result = create_message
    result.body.message.should == 'message(s) queued'
  end
end

describe Plivo::SMS, '.resource_name' do
  it 'should be Message' do
    Plivo::SMS.resource_name.should == 'Message'
  end
end
