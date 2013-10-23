require 'spec_helper'

describe Plivo::RentedNumber, '#unrent', :vcr do
  it 'unrents the number' do
    num = Plivo::RentedNumber.all.first
    num.unrent.status.should == 204
  end
end