module Plivo
  module Base
    class ResourceInterface
      include Plivo::Utils
      def initialize(client, resource_list_json = nil)
        configure_client(client)
        configure_resource_uri
        parse_and_set(resource_list_json) if resource_list_json
      end

      private

      def configure_client(client)
        valid_param?(:client, client, [RestClient, Phlo], true)
        @_client = client
      end

      def configure_resource_uri
        to_join = ['', 'v1', 'Account', @_client.auth_id, @_name, '']
        to_join = ['', 'v1', 'Account', ''] if @_name == 'Account'
        to_join = ['', 'v1', @_name, ''] if @_name == 'phlo'
        @_resource_uri = to_join.join('/')
      end

      def parse_and_set(resource_list_json)
        return unless resource_list_json

        valid_param?(:resource_list_json, resource_list_json, Hash, true)

        resource_list_json.each do |k, v|
          if k == 'objects'
            parse_and_set_list(resource_list_json['objects'])
          elsif k == 'meta'
            @_meta = resource_list_json['meta']
          else
            instance_variable_set("@#{k}", v)
            self.class.send(:attr_reader, k)
          end
        end
      end

      def perform_get(identifier, params = nil)
        valid_param?(:identifier, identifier, [String, Symbol], true)
        response_json = @_client.send_request(@_resource_uri + identifier.to_s + '/', 'GET', params)
        @_resource_type.new(@_client, resource_json: response_json)
      end

      def perform_get_without_identifier(params)
        valid_param?(:params, params, Hash, true)
        response_json = @_client.send_request(@_resource_uri, 'GET', params)
        @_resource_type.new(@_client, resource_json: response_json)
      end

      def perform_create(params, use_multipart_conn=false)
        Response.new(
          @_client.send_request(@_resource_uri, 'POST', params, nil, use_multipart_conn),
          @_identifier_string
        )
      end

      def perform_post(params)
        response_json = @_client.send_request(@_resource_uri, 'POST', params)

        parse_and_set(response_json)
        self
      end

      def parse_and_set_list(list_json)
        return unless list_json
        valid_param?(:list_json, list_json, Array, false)
        @_resource_list = list_json.map do |resource|
          @_resource_type.new(@_client, resource_json: resource)
        end
      end

      def perform_list(params = nil)
        response_json = @_client.send_request(@_resource_uri, 'GET', params)
        parse_and_set(response_json)
        {
          api_id: @api_id,
          meta: @_meta,
          objects: @_resource_list
        }
      end

      def perform_list_without_object(params = nil)
        response_json = @_client.send_request(@_resource_uri, 'GET', params)
        parse_and_set(response_json)
        response_json
      end
    end
  end
end
