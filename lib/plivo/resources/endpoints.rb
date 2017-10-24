module Plivo
  module Resources
    include Plivo::Utils
    class Endpoint < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Endpoint'
        @_identifier_string = 'endpoint_id'
        super
      end

      # @param [Hash] options
      # @option options [String] :password The password for your endpoint username.
      # @option options [String] :alias Alias for this endpoint
      # @option options [String] :app_id The app_id of the application that is to be attached to this endpoint. If app_id is not specified, then the endpoint does not point to any application.
      def update(options = nil)
        return if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[password alias app_id]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      attr_reader :password

      attr_reader :sip_expires

      def sip_contact
        @sip_expires
      end

      def sip_user_agent
        @sip_expires
      end

      def to_s
        {
          alias: @alias,
          application: @application,
          endpoint_id: @endpoint_id,
          resource_uri: @resource_uri,
          sip_contact: @sip_contact,
          sip_expires: @sip_expires,
          sip_registered: @sip_registered,
          sip_uri: @sip_uri,
          sip_user_agent: @sip_user_agent,
          sub_account: @sub_account,
          username: @username,
          password: @password
        }.to_s
      end
    end

    # @!method get
    # @!method create
    # @!method list
    class EndpointInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Endpoint'
        @_resource_type = Endpoint
        @_identifier_string = 'endpoint_id'
        super
      end

      # @param [String] endpoint_id
      def get(endpoint_id)
        valid_param?(:endpoint_id, endpoint_id, [String, Symbol], true)
        perform_get(endpoint_id)
      end

      # @param [String] username
      # @param [String] password
      # @param [String] alias_
      # @param [String] app_id
      def create(username, password, alias_, app_id = nil)
        valid_param?(:username, username, [String, Symbol], true)
        valid_param?(:password, password, [String, Symbol], true)
        valid_param?(:alias, alias_, [String, Symbol], true)

        params = {
          username: username,
          password: password,
          alias: alias_
        }

        params[:app_id] = app_id unless app_id.nil?

        perform_create(params)
      end

      def list
        perform_list
      end

      def each
        endpoint_list = list
        endpoint_list[:objects].each { |endpoint| yield endpoint }
      end

      # @param [String] endpoint_id
      # @param [Hash] options
      # @option options [String] :password The password for your endpoint username.
      # @option options [String] :alias Alias for this endpoint
      # @option options [String] :app_id The app_id of the application that is to be attached to this endpoint. If app_id is not specified, then the endpoint does not point to any application.
      def update(endpoint_id, options = nil)
        valid_param?(:endpoint_id, endpoint_id, [String, Symbol], true)
        Endpoint.new(@_client,
                     resource_id: endpoint_id).update(options)
      end

      # @param [String] endpoint_id
      def delete(endpoint_id)
        valid_param?(:endpoint_id, endpoint_id, [String, Symbol], true)
        Endpoint.new(@_client,
                     resource_id: endpoint_id).delete
      end
    end
  end
end
