module Plivo
  module Resources
    include Plivo::Utils
    class Application < Base::Resource


      def initialize(client, options = nil)
        @_name = 'Application'
        @_identifier_string = 'app_id'
        super
      end

      # @param [Hash] options
      # @option options [String] :answer_url - The URL invoked by Plivo when a call executes this application.
      # @option options [String] :answer_method - The method used to call the answer_url. Defaults to POST.
      # @option options [String] :hangup_url - The URL that will be notified by Plivo when the call hangs up. Defaults to answer_url.
      # @option options [String] :hangup_method - The method used to call the hangup_url. Defaults to POST.
      # @option options [String] :fallback_answer_url - Invoked by Plivo only if answer_url is unavailable or the XML response is invalid. Should contain a XML response.
      # @option options [String] :fallback_method - The method used to call the fallback_answer_url. Defaults to POST.
      # @option options [String] :message_url - The URL that will be notified by Plivo when an inbound message is received. Defaults not set.
      # @option options [String] :message_method - The method used to call the message_url. Defaults to POST.
      # @option options [Boolean] :default_number_app - If set to true, this parameter ensures that newly created numbers, which don't have an app_id, point to this application.
      # @option options [Boolean] :default_endpoint_app - If set to true, this parameter ensures that newly created endpoints, which don't have an app_id, point to this application.
      # @option options [String] :subaccount - Id of the subaccount, in case only subaccount applications are needed.
      # @option options [Boolean] :log_incoming_messages - If set to true, this parameter ensures that incoming messages are logged.
      # @return [Application] Application
      def update(options = nil)
        return perform_update({}) if options.nil?

        valid_param?(:options, options, Hash, true)

        params = {}

        %i[answer_url hangup_url fallback_answer_url message_url subaccount]
          .each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[answer_method hangup_method fallback_method message_method]
          .each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true, %w[GET POST])
            params[param] = options[param]
          end
        end

        %i[default_number_app default_endpoint_app log_incoming_messages].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [TrueClass, FalseClass], true)
            params[param] = options[param]
          end
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      def to_s
        {
          answer_method: @answer_method,
          answer_url: @answer_url,
          app_id: @app_id,
          api_id: @api_id,
          app_name: @app_name,
          default_app: @default_app,
          default_endpoint_app: @default_endpoint_app,
          enabled: @enabled,
          fallback_answer_url: @fallback_answer_url,
          fallback_method: @fallback_method,
          hangup_method: @hangup_method,
          hangup_url: @hangup_url,
          message_method: @message_method,
          message_url: @message_url,
          public_uri: @public_uri,
          resource_uri: @resource_uri,
          sip_uri: @sip_uri,
          sub_account: @sub_account,
          log_incoming_messages: @log_incoming_messages
        }.to_s
      end
    end

    # @!method get
    # @!method create
    # @!method list
    class ApplicationInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Application'
        @_resource_type = Application
        @_identifier_string = 'app_id'
        super
      end

      # @param [String] app_id
      # @return [Application] Application
      def get(app_id)
        valid_param?(:app_id, app_id, [String, Symbol], true)
        perform_get(app_id)
      end

      # @param [String] app_name
      # @param [Hash] options
      # @option options [String] :answer_url - The URL invoked by Plivo when a call executes this application.
      # @option options [String] :answer_method - The method used to call the answer_url. Defaults to POST.
      # @option options [String] :hangup_url - The URL that will be notified by Plivo when the call hangs up. Defaults to answer_url.
      # @option options [String] :hangup_method - The method used to call the hangup_url. Defaults to POST.
      # @option options [String] :fallback_answer_url - Invoked by Plivo only if answer_url is unavailable or the XML response is invalid. Should contain a XML response.
      # @option options [String] :fallback_method - The method used to call the fallback_answer_url. Defaults to POST.
      # @option options [String] :message_url - The URL that will be notified by Plivo when an inbound message is received. Defaults not set.
      # @option options [String] :message_method - The method used to call the message_url. Defaults to POST.
      # @option options [Boolean] :default_number_app - If set to true, this parameter ensures that newly created numbers, which don't have an app_id, point to this application.
      # @option options [Boolean] :default_endpoint_app - If set to true, this parameter ensures that newly created endpoints, which don't have an app_id, point to this application.
      # @option options [String] :subaccount - Id of the subaccount, in case only subaccount applications are needed.
      # @option options [Boolean] :log_incoming_messages - If set to true, this parameter ensures that incoming messages are logged.
      # @return [Application] Application
      def create(app_name, options = nil)
        valid_param?(:app_name, app_name, [String, Symbol], true)
        valid_param?(:options, options, Hash, true) unless options.nil?

        params = {
          app_name: app_name
        }

        return perform_create(params) if options.nil?

        %i[answer_url hangup_url fallback_answer_url message_url subaccount]
          .each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[answer_method hangup_method fallback_method message_method]
          .each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true, %w[GET POST])
            params[param] = options[param]
          end
        end

        %i[default_number_app default_endpoint_app log_incoming_messages].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [TrueClass, FalseClass], true)
            params[param] = options[param]
          end
        end

        perform_create(params)
      end

      ##
      # Lists all applications
      # @param [Hash] options
      # @option options [String] :subaccount
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?

        params = {}

        if options.key?(:subaccount) &&
           valid_param?(:subaccount, options[:subaccount], [String, Symbol], true)
          params[:subaccount] = options[:subaccount]
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer, Integer], true)
            params[param] = options[param]
          end
        end

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        if options.key?(:offset) && options[:offset] < 0
          raise_invalid_request("Offset can't be negative")
        end

        perform_list(params)
      end

      def each
        offset = 0
        loop do
          app_list = list(offset: offset)
          app_list[:objects].each { |app| yield app }
          offset += 20
          return unless app_list.length == 20
        end
      end

      ##
      # Modify an application
      # @param [String] app_id
      # @param [Hash] options
      # @option options [String] :answer_url - The URL invoked by Plivo when a call executes this application.
      # @option options [String] :answer_method - The method used to call the answer_url. Defaults to POST.
      # @option options [String] :hangup_url - The URL that will be notified by Plivo when the call hangs up. Defaults to answer_url.
      # @option options [String] :hangup_method - The method used to call the hangup_url. Defaults to POST.
      # @option options [String] :fallback_answer_url - Invoked by Plivo only if answer_url is unavailable or the XML response is invalid. Should contain a XML response.
      # @option options [String] :fallback_method - The method used to call the fallback_answer_url. Defaults to POST.
      # @option options [String] :message_url - The URL that will be notified by Plivo when an inbound message is received. Defaults not set.
      # @option options [String] :message_method - The method used to call the message_url. Defaults to POST.
      # @option options [Boolean] :default_number_app - If set to true, this parameter ensures that newly created numbers, which don't have an app_id, point to this application.
      # @option options [Boolean] :default_endpoint_app - If set to true, this parameter ensures that newly created endpoints, which don't have an app_id, point to this application.
      # @option options [String] :subaccount - Id of the subaccount, in case only subaccount applications are needed.
      # @option options [Boolean] :log_incoming_messages - If set to true, this parameter ensures that incoming messages are logged.
      # @return [Application] Application
      def update(app_id, options = nil)
        valid_param?(:app_id, app_id, [String, Symbol], true)
        Application.new(@_client,
                        resource_id: app_id).update(options)
      end

      ##
      # Delete an application
      # @param [String] app_id
      def delete(app_id)
        valid_param?(:app_id, app_id, [String, Symbol], true)
        Application.new(@_client,
                        resource_id: app_id).delete
      end
    end
  end
end
