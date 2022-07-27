module Plivo
  module Resources
    include Plivo::Utils
    class Brand < Base::Resource
      def initialize(client, options = nil)
        @_name = '10dlc/Brand'
        @_identifier_string = 'brand_id'
        super
      end
  
      def to_s
        {
          api_id: @api_id,
          brand: @brand
        }.to_s
      end
    end
  
    class BrandInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = '10dlc/Brand'
        @_resource_type = Brand
        @_identifier_string = 'brand_id'
        super
      end
  
        ##
        # Get an Brand
        # @param [String] brand_id
        # @return [Brand] Brand
      def get(brand_id)
        valid_param?(:brand_id, brand_id, [String, Symbol], true)
        perform_get(brand_id)
      end
  
        ##
        # List all Brand
        # @param [Hash] options
        # @option options [String] :type
        # @option options [Status] :status
        # @return [Hash]
      def list(options=nil)
        return perform_list_without_object if options.nil?
  
        params = {}
        %i[status type].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                   [String], true)
            params[param] = options[param]
          end
        end  
        perform_list_without_object(params)
      end
  
        ##
        # Create a new brand
      def create(options=nil)
        valid_param?(:options, options, Hash, true)
        params = {}
        if options.key?(:brand_alias) 
          params[:brand_alias] = options[:brand_alias]
        else
          raise_invalid_request("brand_alias must be provided")
        end
        if options.key?(:brand_type) 
          params[:brand_type] = options[:brand_type]
        else
          raise_invalid_request("brand_type must be provided")
        end
        if options.key?(:profile_uuid) 
          params[:profile_uuid] = options[:profile_uuid]
        else
          raise_invalid_request("profile_uuid must be provided")
        end
        if options.key?(:brand_type) 
          params[:brand_type] = options[:brand_type]
        else
          raise_invalid_request("brand_type must be provided")
        end
        if options.key?(:secondary_vetting) 
          params[:secondary_vetting] = options[:secondary_vetting]
        else
          params[:secondary_vetting] = false
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
        if options.key?(:emailRecipients) 
          params[:emailRecipients] = options[:emailRecipients]
        else
          params[:emailRecipients] = ''
        end
        if options.key?(:campaignName) 
          params[:campaignName] = options[:campaignName]
        else
          params[:campaignName] = ''
        end
        if options.key?(:campaignUseCase) 
          params[:campaignUseCase] = options[:campaignUseCase]
        else
          params[:campaignUseCase] = ''
        end
        if options.key?(:campaignSubUseCases) 
          params[:campaignSubUseCases] = options[:campaignSubUseCases]
        else
          params[:campaignSubUseCases] = []
        end
        if options.key?(:campaignDescription) 
          params[:campaignDescription] = options[:campaignDescription]
        else
          params[:campaignDescription] = ''
        end
        if options.key?(:sampleMessage1) 
          params[:sampleMessage1] = options[:sampleMessage1]
        else
          params[:sampleMessage1] = ''
        end
        if options.key?(:sampleMessage2) 
          params[:sampleMessage2] = options[:sampleMessage2]
        else
          params[:sampleMessage2] = ''
        end
        if options.key?(:embeddedLink) 
          params[:embeddedLink] = options[:embeddedLink]
        else
          params[:embeddedLink] = false
        end
        if options.key?(:embeddedPhone) 
          params[:embeddedPhone] = options[:embeddedPhone]
        else
          params[:embeddedPhone] = false
        end
        if options.key?(:numberPool) 
          params[:numberPool] = options[:numberPool]
        else
          params[:numberPool] = false
        end
        if options.key?(:ageGated) 
          params[:ageGated] = options[:ageGated]
        else
          params[:ageGated] = false
        end
        if options.key?(:directLending) 
          params[:directLending] = options[:directLending]
        else
          params[:directLending] = false
        end
        if options.key?(:subscriberOptin) 
          params[:subscriberOptin] = options[:subscriberOptin]
        else
          params[:subscriberOptin] = false
        end
        if options.key?(:subscriberOptout) 
          params[:subscriberOptout] = options[:subscriberOptout]
        else
          params[:subscriberOptout] = false
        end
        if options.key?(:subscriberHelp) 
          params[:subscriberHelp] = options[:subscriberHelp]
        else
          params[:subscriberHelp] = false
        end
        if options.key?(:affiliateMarketing) 
          params[:affiliateMarketing] = options[:affiliateMarketing]
        else
          params[:affiliateMarketing] = false
        end
        if options.key?(:resellerID) 
          params[:resellerID] = options[:resellerID]
        else
          params[:resellerID] = ''
        end
        perform_create(params)
      end
    end
  end
end