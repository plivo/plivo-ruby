module Plivo
  module Resources
    include Plivo::Utils
    class Subaccount < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Subaccount'
        @_identifier_string = 'auth_id'
        super
      end

      def update(name, enabled = false)
        valid_param?(:name, name, [String, Symbol], true)
        valid_param?(:enabled, enabled, [TrueClass, FalseClass],
                     true, [true, false])

        params = {
          name: name,
          enabled: enabled
        }
        perform_update(params)
      end

      def delete(cascade = false)
        valid_param?(:cascade, cascade, [TrueClass, FalseClass],
          false, [true, false])
        
        params = {
          :cascade => cascade
        }
          
        perform_delete(params)
      end

      def to_s
        {
          account: @account,
          api_id: @api_id,
          auth_id: @auth_id,
          auth_token: @auth_token,
          new_auth_token: @new_auth_token,
          created: @created,
          enabled: @enabled,
          modified: @modified,
          name: @name,
          resource_uri: @resource_uri
        }.to_s
      end
    end

    # @!method get
    # @!method create
    # @!method list
    class SubaccountInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Subaccount'
        @_resource_type = Subaccount
        @_identifier_string = 'auth_id'
        super
      end

      # @param [String] subaccount_id
      def get(subaccount_id)
        valid_subaccount?(subaccount_id, true)
        perform_get(subaccount_id)
      end

      # @param [String] name
      # @param [Boolean] enabled
      def create(name, enabled = false)
        valid_param?(:name, name, [String, Symbol], true)
        valid_param?(:enabled, enabled, [TrueClass, FalseClass],
                     true, [true, false])

        params = {
          name: name,
          enabled: enabled
        }

        perform_create(params)
      end

      # @param [Array] options
      def list(options = nil)
        return perform_list if options.nil?

        params = {}

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

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        perform_list(params)
      end

      def each
        offset = 0
        loop do
          subaccount_list = list(offset: offset)
          subaccount_list[:objects].each { |subaccount| yield subaccount }
          offset += 20
          return unless subaccount_list.length == 20
        end
      end

      def update(subaccount_id, name, enabled = false)
        Subaccount.new(@_client, resource_id: subaccount_id).update(name, enabled)
      end

      def delete(subaccount_id, cascade = false)
        valid_subaccount?(subaccount_id, true)
        Subaccount.new(@_client, resource_id: subaccount_id).delete(cascade)
      end
    end

    class Account < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Account'
        @_identifier_string = 'auth_id'
        super
      end

      def update(details)
        valid_param?(:details, details, Hash, true)

        params = {}
        %i[name city address].each do |param|
          if details.key?(param) && valid_param?(param, details[param], [String, Symbol], true)
            params[param] = details[param]
          end
        end

        raise_invalid_request('One parameter of name, city and address is required') if params == {}
        perform_update(params)
      end

      def to_s
        {
          account_type: @account_type,
          address: @address,
          api_id: @api_id,
          auth_id: @auth_id,
          auto_recharge: @auto_recharge,
          billing_mode: @billing_mode,
          cash_credits: @cash_credits,
          city: @city,
          name: @name,
          resource_uri: @resource_uri,
          state: @state,
          timezone: @timezone
        }.to_s
      end
    end

    class AccountInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Account'
        @_resource_type = Account
        @_identifier_string = 'auth_id'
        super
      end

      def details
        perform_get(@_client.auth_id)
      end

      def update(details)
        Account.new(@_client, resource_id: @_client.auth_id).update(details)
      end
    end
  end
end
