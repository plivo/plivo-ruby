require 'forwardable'

# Wrapper for a collection of API resources
module Plivo
  class ResourceCollection
    extend Forwardable
    include Enumerable
    def_delegators :@objects, :each, :<<, :first, :size

    attr_reader :objects

    # @param [Hash] response a faraday response
    # @param [Class] klass a class referece to the type of Resource of the collection
    def initialize(response, klass = Resource)
      @body = response.body
      @klass = klass
      process_resources
    end

    def meta
      @body['meta']
    end

    private

    def process_resources
      if @body.keys.include?('objects')
        @objects = @body['objects'].map do |obj|
          @klass.new(obj)
        end
      else
        []
      end
    end
  end
end