module Plivo
  module Resources
    include Plivo::Utils
    class Campaign < Base::Resource
      def initialize(client, options = nil)
        @_name = '10dlc/Campaign'
        @_identifier_string = 'campaign_id'
        super
      end
  
      def to_s
        {
          api_id: @api_id,
          campaign: @campaign
        }.to_s
      end
    end
  
    class CampaignInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = '10dlc/Campaign'
        @_resource_type = Campaign
        @_identifier_string = 'campaign_id'
        super
      end
  
        ##
        # Get an Campaign
        # @param [String] campaign_id
        # @return [Campaign] Campaign
      def get(campaign_id)
        valid_param?(:campaign_id, campaign_id, [String, Symbol], true)
        perform_get(campaign_id)
      end
  
        ##
        # List all Campaign
        # @param [Hash] options
        # @option options [String] :brand
        # @option options [Status] :usecase
        # @option options [String] :campaign_source
        # @option options [Status] :limit
        # @option options [Status] :offset
        # @return [Hash]
      def list(options=nil)
        return perform_list_without_object if options.nil?
  
        params = {}
        %i[usecase brand campaign_source limit offset].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                   [String, Integer], true)
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
        perform_list_without_object(params)
      end
  
        ##
        # Create a new Camapign
      def create(options=nil)
        valid_param?(:options, options, Hash, true)
        if not options[:brand_id]
          raise_invalid_request("brand_id must be provided")
        end
        if not options[:vertical]
          raise_invalid_request("vertical must be provided")
        end
        if not options[:usecase]
          raise_invalid_request("usecase must be provided")
        end
        if not options[:message_flow]
          raise_invalid_request("message_flow must be provided")
        end
        if not options[:help_message]
          raise_invalid_request("help_message must be provided")
        end
        if not options[:optout_message]
          raise_invalid_request("optout_message must be provided")
        end
        perform_create(options)
      end
      ##
      # Update Camapign
      def update(campaign_id, options=nil)
        valid_param?(:options, options, Hash, true)
        if not campaign_id
          raise_invalid_request("campaign_id must be provided")
        end
        action = campaign_id
        perform_action_with_identifier(action, 'POST', options)
      end
      ##

      #import campaign
      def import(options=nil)
        valid_param?(:options, options, Hash, true)
        if not options[:campaign_id]
          raise_invalid_request("campaign_id must be provided")
        end
        if not options[:campaign_alias]
          raise_invalid_request("campaign_alias must be provided")
        end
        action = 'Import'
        perform_action_with_identifier(action, 'POST', options)   
      end
      # campaign number link
      #
      def number_link(options=nil)
        valid_param?(:options, options, Hash, true)
        if not options[:campaign_id]
          raise_invalid_request("campaign_id must be provided")
        end
        action = options[:campaign_id] + '/Number'
        perform_action_with_identifier(action, 'POST', options)            
      end
      ##
      #get campaign numbers
      #
      def get_numbers(campaign_id, options = nil)
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
        if options.key?(:offset) && options[:offset] < 0
          raise_invalid_request("Offset can't be negative")
        end
        action = campaign_id + '/Number'
        perform_action_with_identifier(action, 'GET', params)
      end
      ##
      #get campaign number
      #
      def get_number(campaign_id, number)
        action = campaign_id + '/Number/' + number
        perform_action_with_identifier(action, 'GET', nil)
      end
      ##
      #unlink campaign number
      #
      def number_unlink(campaign_id, number, options = nil)
        action = campaign_id + '/Number/' + number
        perform_action_with_identifier(action, 'DELETE', nil)
      end
        ##
        # Delete Campaign
        # @param [String] campaign_id
        def delete(campaign_id)
          valid_param?(:campaign_id, campaign_id, [String, Symbol], true)
          perform_delete(campaign_id)
        end
    end
  end
end
