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
        # @option options [Status] :limit
        # @option options [Status] :offset
        # @return [Hash]
      def list(options=nil)
        return perform_list_without_object if options.nil?
  
        params = {}
        %i[status type limit offset].each do |param|
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
        # Create a new brand
      def create(options=nil)
        valid_param?(:options, options, Hash, true)
        if not options[:brand_alias]
          raise_invalid_request("brand_alias must be provided")
        end
        if not options[:brand_type]
          raise_invalid_request("brand_type must be provided")
        end
        if not options[:profile_uuid]
          raise_invalid_request("profile_uuid must be provided")
        end
        perform_create(options)
      end
    end
  end
end