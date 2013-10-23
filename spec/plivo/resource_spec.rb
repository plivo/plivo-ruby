require 'spec_helper'

describe Plivo::Resource, '.all', :vcr do
  context "for Number resources" do
    it 'loads the index resource' do
      result = Plivo::RentedNumber.all
      result.should be_a Plivo::ResourceCollection
      result.first.should be_a Plivo::RentedNumber
      result.size.should be_a Fixnum
    end
  end
end

describe Plivo::Resource, '.find', :vcr do
  context "for Number resources" do
    it 'loads the index resource' do
      numbers = Plivo::RentedNumber.all
      uri = numbers.first.uri
      rented_number = Plivo::RentedNumber.find(uri)
      rented_number.uri.should == uri
      rented_number.should be_a Plivo::RentedNumber
    end
  end
end

describe Plivo::Resource, '.resource_name' do
  context 'by default' do
    it 'returns the un-namespaced class name' do
      Plivo::Faux = Class.new(Plivo::Resource) {}
      Plivo::Faux.resource_name.should == 'Faux'
    end
  end

  context 'when set explicitly' do
    it 'returns the explicitly set resource name' do
      Plivo::FakeClass = Class.new(Plivo::Resource) do
        self.resource_name = 'Blippity'
      end

      Plivo::FakeClass.resource_name.should == 'Blippity'
    end
  end
end