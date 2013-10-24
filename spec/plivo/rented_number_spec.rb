require 'spec_helper'

describe Plivo::RentedNumber, '#unrent', :vcr do
  it 'unrents the number' do
    num = Plivo::RentedNumber.all.first
    num.unrent.status.should == 204
  end
end

describe Plivo::RentedNumber, '.find', :vcr do
  it 'supports using a purchased phone number instead of a URI' do
    group = Plivo::AvailableNumberGroup.search(country_iso: 'US')
    num = group.first
    payload = num.rent
    purchased_number = payload['numbers'].first['number']
    Plivo::RentedNumber.find(purchased_number).number.should == purchased_number
  end

  it 'supports looking up via a normal URI' do
    numbers = Plivo::RentedNumber.all
    uri = numbers.first.uri
    rented_number = Plivo::RentedNumber.find(uri)
    rented_number.uri.should == uri
    rented_number.should be_a Plivo::RentedNumber
  end
end
