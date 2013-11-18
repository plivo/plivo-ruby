module Plivo
  # @see http://plivo.com/docs/api/endpoint/
  class Endpoint < Resource
    def self.create(params = {})
      response = super
      new(response.body)
    end
  end
end