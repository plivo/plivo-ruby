require 'spec_helper'

describe Plivo::AvailableNumberGroup, '.search', :vcr do
  it 'returns an available number group instance' do
    result = Plivo::AvailableNumberGroup.search(country_iso: 'US')
    result.should be_a Plivo::ResourceCollection
    result.objects.size.should == 20
    result.first.should be_a Plivo::AvailableNumberGroup
  end
end

describe Plivo::AvailableNumberGroup, '#rent', :vcr do
  it 'rents a number' do
    number_groups = Plivo::AvailableNumberGroup.search(country_iso: 'US')
    result = number_groups.first.rent
    result['numbers'].first['number'].should_not be_nil
  end
end