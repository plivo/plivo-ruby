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
      # @param [Hash] options
      # @option options [String] :phone_number_country - Country ISO 2 code for which you are submitted
      # @option options [String] :number_type - This can only take values “local”, “national”, “mobile”, “tollfree”
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the identity is created
      # @option options [String] :last_name - Last name of the user for whom the identity is created
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :proof_type - The type of document that is provided as address proof
      # @option options [String] :id_number - The unique number on the identifier
      # @option options [String] :nationality - Nationality of the user for whom the identity is created
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :alias - Alias name of the identity
      # @option options :file - A File to upload, which needs to be considered the proof of address. Max. file Size = 5 MB. File should be in jpg, pdf, or png format.
      # @option options [String] :id_nationality - Nationality mentioned in the identity proof
      # @option options [String] :birth_place - Birthplace of the user for whom the identity is created
      # @option options [String] :birth_date - Birth date in yyyy-mm-dd format of the user for whom the identity is created
      # @option options [String] :id_issue_date - Issue date in yyyy-mm-dd mentioned in the identity proof
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @return [Identity] Identity

      def update(options = nil)
        params = {}

        unless options.nil?
          valid_param?(:options, options, Hash, true)

          %i[phone_number_country first_name last_name address_line1 address_line2 city region postal_code country_iso
            id_number nationality callback_url alias id_nationality birth_place birth_date id_issue_date business_name fiscal_identification_code street_code municipal_code]
              .each do |param|
            if options.key?(param) &&
                valid_param?(param, options[param], [String, Symbol], true)
              params[param] = options[param]
            end
          end

          if options[:salutation]
            valid_param?(:salutation, options[:salutation], [String, Symbol], true, ['Mr', 'Ms', :Ms, :Mr])
            params[:salutation] = options[:salutation]
          end

          if options[:number_type]
            valid_param?(:number_type, options[:number_type], [String, Symbol], true, ['local', 'national', 'mobile', 'tollfree'])
            params[:number_type] = options[:number_type]
          end

          if options[:proof_type]
            if options[:country_iso]
              if options[:country_iso] == 'ES'
                valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NIF', 'NIE', 'DNI'])
              else
                valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NATIONAL_ID_CARD', 'PASSPORT', 'BUSINESS_REGISTRATION', 'any'])
              end
            else
              valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NIF', 'NIE', 'DNI', 'national_id', 'passport', 'business_id'])
            end
            params[:proof_type] = options[:proof_type]
          end
          unless options[:file].nil?
            valid_param?(:file, options[:file], [String, Symbol], true)
            file_extension = options[:file].split('.')[-1].downcase
            # add check on file size
            content_type = case file_extension
                             when 'jpeg' then 'image/jpeg'
                             when 'jpg' then 'image/jpeg'
                             when 'png' then 'image/png'
                             when 'pdf' then 'application/pdf'
                             else raise_invalid_request("#{file_extension} is not yet supported for upload")
                           end
            file_size = File.size("#{options[:file]}")
            if file_size > 5000000
             raise_invalid_request("Maximum file size can be 5 MB")
            end
            params[:file] = Faraday::UploadIO.new(options[:file], content_type)
          end
        end
        return perform_update(params, true)
      end

      def to_s
        {
          account: @account,
          address_line1: @address_line1,
          address_line2: @address_line2,
          alias: @alias,
          api_id: @api_id,
          city: @city,
          country_iso: @country_iso,
          document_details: @document_details,
          first_name: @first_name,
          id: @id,
          last_name: @last_name,
          postal_code: @postal_code,
          region: @region,
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

        valid_param?(:options, options, Hash, true)
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
      # @param [String] phone_number_country
      # @param [String] number_type
      # @param [String] salutation
      # @param [String] first_name
      # @param [String] last_name
      # @param [String] address_line1
      # @param [String] address_line2
      # @param [String] city
      # @param [String] region
      # @param [String] postal_code
      # @param [String] country_iso
      # @param [String] proof_type
      # @param [String] id_number
      # @param [String] nationality
      # @param [Hash] options
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :alias - Alias name of the identity
      # @option options :file - A File to upload, which needs to be considered the proof of address. Max. file Size = 5 MB. File should be in jpg, pdf, or png format.
      # @option options [String] :id_nationality - Nationality of the user mentioned in the document
      # @option options [String] :birth_place - Birth Place of the user mentioned in the document
      # @option options [String] :birth_date - Birth Date of the user mentioned in the document
      # @option options [String] :id_issue_date - Issued date of the proof being uploaded
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @return [Identity] Identity

      def create(phone_number_country, number_type, salutation, first_name, last_name, address_line1, address_line2,
                 city, region, postal_code, country_iso, proof_type, id_number, nationality, options=nil)
        valid_param?(:phone_number_country, phone_number_country, [String, Symbol], true)
        valid_param?(:number_type, number_type, [String, Symbol], true, ['local', 'national', 'mobile', 'tollfree'])
        valid_param?(:salutation, salutation, [String, Symbol], true, ['Mr', 'Ms', :Ms, :Mr])
        valid_param?(:first_name, first_name, [String, Symbol], true)
        valid_param?(:last_name, last_name, [String, Symbol], true)
        valid_param?(:address_line1, address_line1, [String, Symbol], true)
        valid_param?(:address_line2, address_line2, [String, Symbol], true)
        valid_param?(:city, city, [String, Symbol], true)
        valid_param?(:region, region, [String, Symbol], true)
        valid_param?(:postal_code, postal_code, [String, Symbol], true)
        valid_param?(:country_iso, country_iso, [String, Symbol], true)
        valid_param?(:id_number, id_number, [String, Symbol], true)
        valid_param?(:nationality, nationality, [String, Symbol], true)

        params = {
            phone_number_country: phone_number_country,
            number_type: number_type,
            salutation: salutation,
            first_name: first_name,
            last_name: last_name,
            address_line1: address_line1,
            address_line2: address_line2,
            city: city,
            region: region,
            postal_code: postal_code,
            country_iso: country_iso,
            id_number: id_number,
            nationality: nationality
        }

        return perform_create(params, true) if options.nil?
        valid_param?(:options, options, Hash, true)
        unless options[:file].nil?
          valid_param?(:file, options[:file], [String, Symbol], true)
          file_extension = options[:file].split('.')[-1].downcase

          content_type = case file_extension
                           when 'jpeg' then 'image/jpeg'
                           when 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'pdf' then 'application/pdf'
                           else raise_invalid_request("#{file_extension} is not yet supported for upload")
                         end
          file_size = File.size("#{options[:file]}")
          if file_size > 5000000
            raise_invalid_request("Maximum file size can be 5 MB")
          end
          params[:file] = Faraday::UploadIO.new(options[:file], content_type)
        end

        if country_iso == 'ES'
          valid_param?(:fiscal_identification_code, options[:fiscal_identification_code], [String, Symbol], true)
          valid_param?(:proof_type, proof_type, [String, Symbol], true, ['NIF', 'NIE', 'DNI'])
          params[:proof_type] = proof_type
          params[:fiscal_identification_code] = options[:fiscal_identification_code]
        elsif country_iso == 'DK'
          valid_param?(:street_code, options[:street_code], [String, Symbol], true)
          valid_param?(:municipal_code, options[:municipal_code], [String, Symbol], true)
          params[:street_code] = options[:street_code]
          params[:municipal_code] = options[:municipal_code]
        else
          valid_param?(:proof_type, proof_type, [String, Symbol], true, ['NATIONAL_ID_CARD', 'PASSPORT', 'BUSINESS_REGISTRATION', 'any'])
          params[:proof_type] = proof_type
        end

        %i[callback_url alias id_nationality birth_place birth_date id_issue_date business_name fiscal_identification_code street_code municipal_code]
            .each do |param|
          if options.key?(param) &&
              valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end
        perform_create(params, true)
      end

      # Update an identity
      # @param [String] identity_id
      # @param [Hash] options
      # @option options [String] :phone_number_country - Country ISO 2 code for which you are submitted
      # @option options [String] :number_type - This can only take values “local”, “national”, “mobile”, “tollfree”
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the identity is created
      # @option options [String] :last_name - Last name of the user for whom the identity is created
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :proof_type - The type of document that is provided as address proof
      # @option options [String] :id_number - The unique number on the identifier
      # @option options [String] :nationality - Nationality of the user for whom the identity is created
      # @option options [String] :callback_url - The callback URL that gets the result of identity creation POSTed to.
      # @option options [String] :alias - Alias name of the identity
      # @option options :file - A File to upload, which needs to be considered the proof of address. Max. file Size = 5 MB. File should be in jpg, pdf, or png format.
      # @option options [String] :id_nationality - Nationality mentioned in the identity proof
      # @option options [String] :birth_place - Birthplace of the user for whom the identity is created
      # @option options [String] :birth_date - Birth date in yyyy-mm-dd format of the user for whom the identity is created
      # @option options [String] :id_issue_date - Issue date in yyyy-mm-dd mentioned in the identity proof
      # @option options [String] :business_name - Business name of the user for whom the identity is created.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @return [Identity] Identity
      def update(identity_id, options=nil)
        valid_param?(:identity_id, identity_id, [String, Symbol], true)
        Identity.new(@_client,
                    resource_id: identity_id).update(options)
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
