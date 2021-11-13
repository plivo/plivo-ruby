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
      def create(params)
          perform_create(params)
      end
    end
  end
end