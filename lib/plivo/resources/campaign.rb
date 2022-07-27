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
        # @return [Hash]
      def list(options=nil)
        return perform_list_without_object if options.nil?
  
        params = {}
        %i[usecase brand].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                   [String], true)
            params[param] = options[param]
          end
        end  
        perform_list_without_object(params)
      end
  
        ##
        # Create a new Camapign
      def create(options=nil)
        valid_param?(:options, options, Hash, true)
        params = {}
        if options.key?(:brand_id) 
          params[:brand_id] = options[:brand_id]
        else
          raise_invalid_request("brand_id must be provided")
        end
        if options.key?(:vertical) 
          params[:vertical] = options[:vertical]
        else
          raise_invalid_request("vertical must be provided")
        end
        if options.key?(:usecase) 
          params[:usecase] = options[:usecase]
        else
          raise_invalid_request("usecase must be provided")
        end
        if options.key?(:description) 
          params[:description] = options[:description]
        else
          params[:description] = ''
        end
        if options.key?(:sample1) 
          params[:sample1] = options[:sample1]
        else
          params[:sample1] = ''
        end
        if options.key?(:sample2) 
          params[:sample2] = options[:sample2]
        else
          params[:sample2] = ''
        end
        if options.key?(:sample3) 
          params[:sample3] = options[:sample3]
        else
          params[:sample3] = ''
        end
        if options.key?(:sample4) 
          params[:sample4] = options[:sample4]
        else
          params[:sample4] = ''
        end
        if options.key?(:sample5) 
          params[:sample5] = options[:sample5]
        else
          params[:sample5] = ''
        end
        if options.key?(:reseller_id) 
          params[:reseller_id] = options[:reseller_id]
        else
          params[:reseller_id] = ''
        end
        if options.key?(:url) 
          params[:url] = options[:url]
        else
          params[:url] = ''
        end
        if options.key?(:method) 
          params[:method] = options[:method]
        else
          params[:method] = 'POST'
        end
        if options.key?(:subaccount_id) 
          params[:subaccount_id] = options[:subaccount_id]
        else
          params[:subaccount_id] = ''
        end
        if options.key?(:embedded_link) 
          params[:embedded_link] = options[:embedded_link]
        else
          params[:embedded_link] = false
        end
        if options.key?(:embedded_phone) 
          params[:embedded_phone] = options[:embedded_phone]
        else
          params[:embedded_phone] = false
        end
        if options.key?(:age_gated) 
          params[:age_gated] = options[:age_gated]
        else
          params[:age_gated] = false
        end
        if options.key?(:direct_lending) 
          params[:direct_lending] = options[:direct_lending]
        else
          params[:direct_lending] = false
        end
        if options.key?(:affiliate_marketing) 
          params[:affiliate_marketing] = options[:affiliate_marketing]
        else
          params[:affiliate_marketing] = false
        end
        if options.key?(:subscriber_optout) 
          params[:subscriber_optout] = options[:subscriber_optout]
        else
          params[:subscriber_optout] = true
        end
        if options.key?(:subscriber_optin) 
          params[:subscriber_optin] = options[:subscriber_optin]
        else
          params[:subscriber_optin] = true
        end
        if options.key?(:subscriber_help) 
          params[:subscriber_help] = options[:subscriber_help]
        else
          params[:subscriber_help] = true
        end
        if options.key?(:campaign_alias) 
          params[:campaign_alias] = options[:campaign_alias]
        else
          params[:campaign_alias] = ''
        end
        if options.key?(:sub_usecases) 
          params[:sub_usecases] = options[:sub_usecases]
        else
          params[:sub_usecases] = []
        end
        perform_create(params)
      end
      ##
      # campaign number link
      #
      def number_link(options=nil)
        valid_param?(:options, options, Hash, true)
        params = {}
        if options.key?(:campaign_id) 
          params[:campaign_id] = options[:campaign_id]
        else
          raise_invalid_request("campaign_id must be provided")
        end
        if options.key?(:url) 
          params[:url] = options[:url]
        else
          params[:url] = ''
        end
        if options.key?(:method) 
          params[:method] = options[:method]
        else
          params[:method] = 'POST'
        end
        if options.key?(:subaccount_id) 
          params[:subaccount_id] = options[:subaccount_id]
        else
          params[:subaccount_id] = ''
        end
        if options.key?(:numbers) 
          params[:numbers] = options[:numbers]
        else
          params[:numbers] = []
        end
        action = params[:campaign_id] + '/Number'
        perform_action(action, 'POST', params, true)            
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
        perform_action(action, 'GET', params, true)
      end
      ##
      #get campaign number
      #
      def get_number(campaign_id, number)
        action = campaign_id + '/Number/' + number
        perform_action(action, 'GET', nil, true)
      end
      ##
      #unlink campaign number
      #
      def number_unlink(campaign_id, number)
        action = campaign_id + '/Number/' + number
        perform_action(action, 'DELETE', nil, true)
      end
    end
  end
end