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
            def list(options = nil)
              return perform_list_without_object if options.nil?
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
              perform_list_without_object(params)
            end

             # Delete an Profile
             # @param [String] profile_uuid
            def delete(profile_uuid)
                valid_param?(:profile_uuid, profile_uuid, [String, Symbol], true)
                perform_action_with_identifier(profile_uuid, 'DELETE', nil)
            end
        
              ##
              # Create a new Profile
            def create(options = nil)
                valid_param?(:options, options, Hash, true)
                if not options[:profile_alias]
                    raise_invalid_request("profile_alias must be provided")
                end
                if not options[:customer_type]
                    raise_invalid_request("customer_type must be provided")
                end
                if not options[:entity_type]
                    raise_invalid_request("entity_type must be provided")
                end
                if not options[:company_name]
                    raise_invalid_request("company_name must be provided")
                end
                if not options[:vertical]
                    raise_invalid_request("vertical must be provided")
                end
                perform_create(options)
            end

            ##
            # Update a Profile
            # {'address': {}, 'authorized_contact': {}, 'entity_type':'', 'vertical': '', 'company_name': '', 'website':'', 'business_contact_email':''} 
            def update(profile_uuid, options = nil)
              valid_param?(:options, options, Hash, true)
              perform_action_with_identifier(profile_uuid, "POST", options)
            end
        end
    end
end