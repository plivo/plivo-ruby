
# Base class for all API resource classes.
module Plivo
  class Resource < Hashie::Mash
    class << self
      def resource_name=(name)
        @resource_name = name
      end

      def resource_name
        @resource_name || self.to_s.split('::').last
      end

      # @return [Plivo::RestAPI]
      def client
        Plivo::RestAPI.client
      end

      # @param [String] uri the uri representing a resource to retrieve
      def find(uri, params = {})
        new(client.request("GET", uri, params).body)
      end

      def all(opts = {})
        ResourceCollection.new(client.request("GET", resource_name))
      end
    end

    # Convenience method.
    #
    # @return [String]
    def uri
      resource_uri
    end

    def client
      self.class.client
    end
  end
end