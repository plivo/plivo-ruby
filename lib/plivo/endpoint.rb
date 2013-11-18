module Plivo
  # @see http://plivo.com/docs/api/endpoint/
  class Endpoint < Resource
    def self.create(params = {})
      response = super
      attrs = response.body
      new(attrs.merge('resource_uri' => uri_from_id(attrs['endpoint_id'])))
    end
  end
end
