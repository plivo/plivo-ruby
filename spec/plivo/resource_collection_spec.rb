require 'spec_helper'

describe Plivo::ResourceCollection, 'initialize' do
  context 'when passed a body with an "objects" key' do
    it 'returns a collection of Plivo::Resource objects' do
      body = {
        'objects' => [{'id' => 123}]
      }
      response = Faraday::Response.new(body: body)
      coll = Plivo::ResourceCollection.new(response)
      coll.objects.size.should == 1
      coll.objects.first.id.should == 123
    end
  end
end

describe Plivo::ResourceCollection, 'method forwarding' do
  [:each, :first, :size].each do |method|
    it "delegates #{method} to the @objects collection" do
      response = collection_response
      coll = Plivo::ResourceCollection.new(response)
      coll.objects.expects(method)
      coll.send(method)
    end
  end
end