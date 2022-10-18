module Plivo
    module Resources
      include Plivo::Utils
      class BrandUsecase < Base::Resource
        def initialize(client, options = nil)
          @_name = '10dlc/Brand/usecases'
          @_identifier_string = 'brand_id'
          super
        end
    
        def to_s
          {
            api_id: @api_id,
            use_cases: @use_cases,
            brand_id: @brand_id
          }.to_s
        end
      end
    
      class BrandUsecaseInterface < Base::ResourceInterface
        def initialize(client, resource_list_json = nil)
          @_name = '10dlc/Brand/usecases'
          @_resource_type = BrandUsecase
          @_identifier_string = 'brand_id'
          super
        end
    
          ##
          # Get BrandUsecase
          # @param [String] brand_id
          # @return [Brand] BrandUsecase
        def get(brand_id)
          valid_param?(:brand_id, brand_id, [String, Symbol], true)
          perform_get(brand_id)
        end
    
      end
    end
  end