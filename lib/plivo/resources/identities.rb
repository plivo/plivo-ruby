module Plivo
  module Resources
    include Plivo::Utils
    class Identity < Base::Resource

      def initialize(client, options = nil)
        @_name = 'Verification/Identity'
        @_identifier_string = 'id'
        super
      end

      def delete
        perform_delete
      end

      # Update an identity
      # @param [String] identity_id
      # @param [String] file_to_upload
      # @param [Hash] options
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the identity is created
      # @option options [String] :last_name - Last name of the user for whom the identity is created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :birth_place - Birthplace of the user for whom the identity is created
      # @option options [String] :birth_date - Birth date in yyyy-mm-dd format of the user for whom the identity is created
      # @option options [String] :nationality - Nationality of the user for whom the identity is created
      # @option options [String] :id_nationality - Nationality mentioned in the identity proof
      # @option options [String] :id_issue_date - Issue date in yyyy-mm-dd mentioned in the identity proof
      # @option options [String] :id_type -
      # @option options [String] :id_number - The unique number on the identifier
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :alias - Alias name of the identity
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :subaccount - The link to the subaccount resource associated with the application. If the application belongs to the main account, this field will be null.
      # @return [Identity] Identity
      def update(file_to_upload = nil, options = nil)
        params = {}

        unless options.nil?
          %i[salutation first_name last_name country_iso birth_place birth_date nationality id_nationality id_issue_date
             id_type id_number address_line1 address_line2 city region postal_code alias business_name
             fiscal_identification_code street_code municipal_code callback_url subaccount
            ]
              .each do |param|
            if options.key?(param) &&
                valid_param?(param, options[param], [String, Symbol], true)
              params[param] = options[param]
            end
          end

          %i[auto_correct_address]
              .each do |param|
            if options.key?(param) &&
                valid_param?(param, options[param], nil, true, [true, false])
              params[param] = options[param]
            end
          end
        end

        unless file_to_upload.nil?
          file_extension = file_to_upload.split('.')[-1]

          content_type = case file_extension
                           when 'jpeg' then 'image/jpeg'
                           when 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'pdf' then 'application/pdf'
                           else raise_invalid_request("#{file_extension} is not yet supported for upload")
                         end

          params[:file] = Faraday::UploadIO.new(file_to_upload, content_type)
        end

        return perform_update(params, true)
      end

      def to_s
        {
          account: @account,
          alias: @alias,
          api_id: @api_id,
          country_iso: @country_iso,
          document_details: @document_details,
          first_name: @first_name,
          id: @id,
          id_number: @id_number,
          id_type: @id_type,
          last_name: @last_name,
          nationality: @nationality,
          salutation: @salutation,
          subaccount: @subaccount,
          url: @url,
          validation_status: @validation_status,
          verification_status: @verification_status
        }.to_s
      end
    end

    class IdentityInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Verification/Identity'
        @_resource_type = Identity
        @_identifier_string = 'id'
        super
      end

      ##
      # Get an identity
      # @param [String] identity_id
      # @return [Identity] Identity
      def get(identity_id)
        valid_param?(:identity_id, identity_id, [String, Symbol], true)
        perform_get(identity_id)
      end

      ##
      # List all identities
      # @param [Hash] options
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :customer_name - Name of the customer or business that is mentioned in the identity
      # @option options [String] :alias - Friendly name of the id proof
      # @option options [String] :verification_status - The status of the identity: pending. accepted, rejected, null
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options=nil)
        return perform_list if options.nil?

        params = {}

        %i[country_iso customer_name alias].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[verification_status].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [String, Symbol], true, ['pending', 'accepted', 'rejected',
                                                                          :pending, :accepted, :rejected])
            params[param] = options[param]
          end
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer], true)
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

      ##
      # Create a new identity
      # @param [String] country_iso
      # @param [String] salutation
      # @param [String] first_name
      # @param [String] last_name
      # @param [String] birth_place
      # @param [String] birth_date
      # @param [String] nationality
      # @param [String] id_nationality
      # @param [String] id_issue_date
      # @param [String] id_type
      # @param [String] id_number
      # @param [String] address_line1
      # @param [String] address_line2
      # @param [String] city
      # @param [String] region
      # @param [String] postal_code
      # @param [String] file_to_upload
      # @param [Hash] options
      # @option options [String] :alias - Alias name of the identity
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :subaccount - The link to the subaccount resource associated with the application. If the application belongs to the main account, this field will be null.
      # @return [Identity] Identity
      def create(country_iso, salutation, first_name, last_name, birth_place, birth_date, nationality,
                 id_nationality, id_issue_date, id_type, id_number, address_line1, address_line2,
                 city, region, postal_code, file_to_upload=nil, options=nil)
        valid_param?(:country_iso, country_iso, [String, Symbol], true)
        valid_param?(:salutation, salutation, [String, Symbol], true, ['Mr', 'Ms', :Ms, :Mr])
        valid_param?(:first_name, first_name, [String, Symbol], true)
        valid_param?(:last_name, last_name, [String, Symbol], true)
        valid_param?(:birth_place, birth_place, [String, Symbol], true)
        valid_param?(:birth_date, birth_date, [String, Symbol], true)
        valid_param?(:nationality, nationality, [String, Symbol], true)
        valid_param?(:id_nationality, id_nationality, [String, Symbol], true)
        valid_param?(:id_issue_date, id_issue_date, [String, Symbol], true)
        valid_param?(:id_type, id_type, [String, Symbol], true)
        valid_param?(:id_number, id_number, [String, Symbol], true)
        valid_param?(:address_line1, address_line1, [String, Symbol], true)
        valid_param?(:address_line2, address_line2, [String, Symbol], true)
        valid_param?(:city, city, [String, Symbol], true)
        valid_param?(:region, region, [String, Symbol], true)
        valid_param?(:postal_code, postal_code, [String, Symbol], true)

        params = {
            country_iso: country_iso,
            salutation: salutation,
            first_name: first_name,
            last_name: last_name,
            birth_place: birth_place,
            birth_date: birth_date,
            nationality: nationality,
            id_nationality: id_nationality,
            id_issue_date: id_issue_date,
            id_type: id_type,
            id_number: id_number,
            address_line1: address_line1,
            address_line2: address_line2,
            city: city,
            region: region,
            postal_code: postal_code
        }

        unless file_to_upload.nil?
          file_extension = file_to_upload.split('.')[-1]

          content_type = case file_extension
                           when 'jpeg' then 'image/jpeg'
                           when 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'pdf' then 'application/pdf'
                           else raise_invalid_request("#{file_extension} is not yet supported for upload")
                         end

          params[:file] = Faraday::UploadIO.new(file_to_upload, content_type)
        end

        %i[alias business_name fiscal_identification_code street_code municipal_code callback_url subaccount]
            .each do |param|
          if options.key?(param) &&
              valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[auto_correct_address]
            .each do |param|
          if options.key?(param) &&
              valid_param?(param, options[param], nil, true, [true, false])
            params[param] = options[param]
          end
        end

        perform_create(params, true)
      end

      # Update an identity
      # @param [String] identity_id
      # @param [String] file_to_upload
      # @param [Hash] options
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the identity is created
      # @option options [String] :last_name - Last name of the user for whom the identity is created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :birth_place - Birthplace of the user for whom the identity is created
      # @option options [String] :birth_date - Birth date in yyyy-mm-dd format of the user for whom the identity is created
      # @option options [String] :nationality - Nationality of the user for whom the identity is created
      # @option options [String] :id_nationality - Nationality mentioned in the identity proof
      # @option options [String] :id_issue_date - Issue date in yyyy-mm-dd mentioned in the identity proof
      # @option options [String] :id_type -
      # @option options [String] :id_number - The unique number on the identifier
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :alias - Alias name of the identity
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :subaccount - The link to the subaccount resource associated with the application. If the application belongs to the main account, this field will be null.
      # @return [Identity] Identity
      def update(identity_id, file_to_upload=nil, options=nil)
        Identity.new(@_client,
                    resource_id: identity_id).update(file_to_upload, options)
      end

      ##
      # Delete an identity
      # @param [String] identity_id
      def delete(identity_id)
        valid_param?(:identity_id, identity_id, [String, Symbol], true)
        Identity.new(@_client,
                    resource_id: identity_id).delete
      end
    end
  end
end