module Plivo
  module Base
    class Resource
      attr_reader :id
      include Plivo::Utils

      def initialize(client, options = nil)
        configure_client(client)
        configure_options(options) if options
        configure_resource_uri
        @_is_voice_request = false
      end

      private

      def configure_client(client)
        valid_param?(:client, client, [RestClient, Phlo], true)
        @_client = client
      end

      def configure_options(options)
        valid_param?(:options, options, Hash, false)
        @id = options[:resource_id] if options.key?(:resource_id)
        parse_and_set(options[:resource_json]) if options.key?(:resource_json)
      end

      def configure_resource_uri
        to_join = @id ? [@_client.auth_id, @_name, @id] : [@_client.auth_id, @_name]
        to_join = ['', 'v1', 'Account'] << to_join

        if @_name == 'Account'
          @id = @_client.auth_id
          to_join = ['', 'v1', 'Account', @id]
        end

        to_join << ''
        @_resource_uri = to_join.join('/')
      end

      def parse_and_set(resource_json)
        return unless resource_json

        valid_param?(:resource_json, resource_json, Hash, true)

        resource_json.each do |k, v|
          instance_variable_set("@#{k}", v)
          self.class.send(:attr_reader, k)
        end

        return unless @_identifier_string && (resource_json.key? @_identifier_string)
        @id = resource_json[@_identifier_string]
      end

      def set_instance_variables(hash)
        hash.each do |k, v|
          instance_var_name = "@#{k}"

          if v.is_a?(Hash)
            instance_variable_set(instance_var_name, v)
            self.class.send(:attr_reader, k.to_sym)
            v.each do |nested_k, nested_v|
              instance_var_name = "@#{nested_k}"
              instance_variable_set(instance_var_name, nested_v)
              self.class.send(:attr_reader, nested_k.to_sym)
            end
          else
            instance_variable_set(instance_var_name, v)
            self.class.send(:attr_reader, k.to_sym)
          end
        end
      end

      def parse_and_set_response(resource_json)
        return unless resource_json.is_a?(Hash)

        set_instance_variables(resource_json)

        if @_identifier_string && resource_json.key?(@_identifier_string)
          @id = resource_json[@_identifier_string]
        end
      end

      def perform_update(params, use_multipart_conn = false)
        unless @id
          raise_invalid_request("Cannot update a #{@_name} resource "\
                                  'without an identifier')
        end

        response_json = @_client.send_request(@_resource_uri, 'POST', params, nil, use_multipart_conn, is_voice_request: @_is_voice_request)

        parse_and_set(params)
        parse_and_set(response_json)
        self
      end

      def perform_masking_update(params, use_multipart_conn = false)
        unless @id
          raise_invalid_request("Cannot update a #{@_name} resource "\
                                  'without an identifier')
        end

        response_json = @_client.send_request(@_resource_uri, 'POST', params, nil, use_multipart_conn, is_voice_request: @_is_voice_request)
        parse_and_set(params)
        parse_and_set_response(response_json)
        self
      end

      def perform_action(action = nil, method = 'GET', params = nil, parse = false)
        resource_path = action ? @_resource_uri + action + '/' : @_resource_uri
        response = @_client.send_request(resource_path, method, params,nil,false,is_voice_request: @_is_voice_request)
        parse ? parse_and_set(response) : self
        method == 'POST' ? parse_and_set(params) : self
        self
      end

      def perform_custome_action(action = nil, method = 'GET', params = nil, parse = false)
        resource_path = action ? @_resource_uri + action + '/' : @_resource_uri
        response = @_client.send_request(resource_path, method, params,nil,false,is_voice_request: @_is_voice_request)
        parse ? parse_and_set(response) : self
        method == 'POST' ? parse_and_set(params) : self
        self
      end

      def perform_action_apiresponse(action = nil, method = 'GET', params = nil, parse = false)
        resource_path = action ? @_resource_uri + action + '/' : @_resource_uri
        response = @_client.send_request(resource_path, method, params,nil,false,is_voice_request: @_is_voice_request)
        parse ? parse_and_set(response) : self
        method == 'POST' ? parse_and_set(params) : self
        method == 'DELETE' ? parse_and_set(params) : self
        return response
      end

      def perform_custom_action_apiresponse(action = nil, method = 'GET', params = nil, parse = false)
        resource_path = action ? '/v1/Account/' + @_client.auth_id + '/'+ action + '/' : @_resource_uri
        response = @_client.send_request(resource_path, method, params,nil,false,is_voice_request: @_is_voice_request)
        parse ? parse_and_set(response) : self
        method == 'POST' ? parse_and_set(params) : self
        method == 'DELETE' ? parse_and_set(params) : self
        return response
      end

      def perform_delete(params=nil)
        unless @id
          raise_invalid_request("Cannot delete a #{@_name} resource "\
                                  'without an identifier')
        end

        Response.new(@_client.send_request(@_resource_uri, 'DELETE', params, nil, false, is_voice_request: @_is_voice_request),
                     @_identifier_string)
      end

      def perform_run(params)
        response_json = @_client.send_request(@_resource_uri, 'POST', params, nil,false,is_voice_request: @_is_voice_request)
        parse_and_set(response_json)
        Response.new(response_json, @_identifier_string)
      end
    end

    class SecondaryResource < Resource
      attr_reader :secondary_id
      def initialize(client, options = nil)
        super
        configure_secondary_options(options) if options
        configure_secondary_resource_uri
      end

      def configure_secondary_options(options)
        valid_param?(:options, options, Hash, false)
        @secondary_id = options[:member_id] if options.key?(:member_id)
        secondary_parse_and_set(options[:resource_json]) if options.key?(:resource_json)
      end

      def secondary_parse_and_set(resource_json)
        return unless resource_json

        valid_param?(:resource_json, resource_json, Hash, true)
        return unless @_secondary_identifier_string && (resource_json.key? @_secondary_identifier_string)
        @secondary_id = resource_json[@_secondary_identifier_string]
      end

      def configure_secondary_resource_uri
        to_join = @secondary_id ? [@_client.auth_id, @_name, @id, @_secondary_name, @secondary_id] : [@_client.auth_id, @_name, @id]
        to_join = ['', 'v1', 'Account'] << to_join
        to_join << ''
        @_resource_uri = to_join.join('/')
      end
    end
  end
end