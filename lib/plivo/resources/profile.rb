module Plivo
    module Resources
        include Plivo::Utils
        class Profile < Base::Resource
            def initialize(client, options = nil)
              @_name = 'Profile'
              @_identifier_string = 'profile_uuid'
              super
            end
        
            def to_s
              {
                api_id: @api_id,
                profile: @profile
              }.to_s
            end
        end
        class ProfileInterface < Base::ResourceInterface
            def initialize(client, resource_list_json = nil)
                @_name = 'Profile'
                @_resource_type = Profile
                @_identifier_string = 'profile_uuid'
                super
            end
        
              ##
              # Get an Profile
              # @param [String] profile_uuid
              # @return [Profile] Profile
            def get(profile_uuid)
                valid_param?(:profile_uuid, profile_uuid, [String, Symbol], true)
                perform_get(profile_uuid)
            end

              # List all Profile
            def list
              return perform_list_without_object
            end

             # Delete an Profile
             # @param [String] profile_uuid
            def delete(profile_uuid)
                valid_param?(:profile_uuid, profile_uuid, [String, Symbol], true)
                perform_delete(profile_uuid)
            end
        
              ##
              # Create a new Profile
            def create(options = nil)
                valid_param?(:options, options, Hash, true)
                params = {}
                if options.key?(:originator) 
                    params[:originator] = options[:originator]
                else
                    params[:originator] = ''
                end
                if options.key?(:profile_alias) 
                    params[:profile_alias] = options[:profile_alias]
                else
                    raise_invalid_request("profile_alias must be provided")
                end
                if options.key?(:customer_type) 
                    params[:customer_type] = options[:customer_type]
                else
                    raise_invalid_request("customer_type must be provided")
                end
                if options.key?(:entity_type) 
                    params[:entity_type] = options[:entity_type]
                else
                    raise_invalid_request("entity_type must be provided")
                end
                if options.key?(:company_name) 
                    params[:company_name] = options[:company_name]
                else
                    raise_invalid_request("company_name must be provided")
                end
                if options.key?(:vertical) 
                    params[:vertical] = options[:vertical]
                else
                    raise_invalid_request("vertical must be provided")
                end
                if options.key?(:alt_business_id) 
                    params[:alt_business_id] = options[:alt_business_id]
                else
                    params[:alt_business_id] = ''
                end
                if options.key?(:alt_business_id_type) 
                    params[:alt_business_id_type] = options[:alt_business_id_type]
                else
                    params[:alt_business_id_type] = ''
                end
                if options.key?(:plivo_subaccount) 
                    params[:plivo_subaccount] = options[:plivo_subaccount]
                else
                    params[:plivo_subaccount] = ''
                end
                if options.key?(:ein) 
                    params[:ein] = options[:ein]
                else
                    params[:ein] = ''
                end
                if options.key?(:ein_issuing_country) 
                    params[:ein_issuing_country] = options[:ein_issuing_country]
                else
                    params[:ein_issuing_country] = ''
                end
                if options.key?(:stock_symbol) 
                    params[:stock_symbol] = options[:stock_symbol]
                else
                    params[:stock_symbol] = ''
                end
                if options.key?(:stock_exchange) 
                    params[:stock_exchange] = options[:stock_exchange]
                else
                    params[:stock_exchange] = ''
                end
                if options.key?(:website) 
                    params[:website] = options[:website]
                else
                    params[:website] = ''
                end
                if options.key?(:address) 
                    params[:address] = options[:address]
                else
                    params[:address] = {}
                end
                if options.key?(:authorized_contact) 
                    params[:authorized_contact] = options[:authorized_contact]
                else
                    params[:authorized_contact] = {}
                end
                perform_create(params)
            end
        end
    end
end