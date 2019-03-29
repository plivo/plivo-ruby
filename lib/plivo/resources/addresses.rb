module Plivo
  module Resources
    include Plivo::Utils
    class Address < Base::Resource

      def initialize(client, options = nil)
        @_name = 'Verification/Address'
        @_identifier_string = 'id'
        super
      end

      def delete
        perform_delete
      end

      ##
      # Update an address
      # @param [String] file_to_upload
      # @param [Hash] options
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the address is created
      # @option options [String] :last_name - Last name of the user for whom the address is created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :alias - Alias name of the address
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :callback_url - The callback URL that gets the result of address creation POSTed to.
      # @option options [String] :phone_number_country
      # @option options [String] :number_type
      # @option options [String] :fiscal_identification_code
      # @option options [String] :street_code
      # @option options [String] :municipal_code
      # @option options [String] :file
      # @option options [String] :proof_type
      # @option options [String] :id_number

      # @return [Address] Address
      def update(options = nil)
        params = {}

        unless options.nil?
          valid_param?(:options, options, Hash, true)

          %i[first_name last_name country_iso address_line1 address_line2 city region postal_code alias callback_url phone_number_country fiscal_identification_code street_code municipal_code file id_number]
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
              valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NIF', 'NIE', 'DNI', 'NATIONAL_ID_CARD', 'PASSPORT', 'BUSINESS_REGISTRATION', 'any'])
            end
            params[:proof_type] = options[:proof_type]
          end

          unless options[:file].nil?
            valid_param?(:file, options[:file], [String, Symbol], true)
            file_extension = options[:file].split('.')[-1]

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

    class AddressInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Verification/Address'
        @_resource_type = Address
        @_identifier_string = 'id'
        super
      end

      ##
      # Get an address
      # @param [String] address_id
      # @return [Address] Address
      def get(address_id)
        valid_param?(:address_id, address_id, [String, Symbol], true)
        perform_get(address_id)
      end

      ##
      # List all addresses
      # @param [Hash] options
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :customer_name - Name of the customer or business that is mentioned in the address
      # @option options [String] :alias - Friendly name of the id proof
      # @option options [String] :verification_status - The status of the address: pending. accepted, rejected, null
      # @option options [String] :validation_status - The status of the address: pending. accepted, rejected, null
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options=nil)
        return perform_list if options.nil?

        params = {}
        valid_param?(:options, options, Hash, true)

        %i[country_iso customer_name alias].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[verification_status validation_status].each do |param|
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
      # Create a new address
      # @param [String] phone_number_country
      # @param [String] number_type
      # @param [String] country_iso
      # @param [String] salutation
      # @param [String] first_name
      # @param [String] last_name
      # @param [String] address_line1
      # @param [String] address_line2
      # @param [String] city
      # @param [String] region
      # @param [String] postal_code
      # @param [Hash] options
      # @option options [String] :alias - Alias name of the address
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :fiscal_identification_code - The code is valid for businesses alone
      # @option options [String] :street_code - Street code of the address
      # @option options [String] :municipal_code - Municipal code of the address
      # @option options [String] :callback_url - The callback URL that gets the result of address creation POSTed to.
      # @option options :file - A File to upload, which needs to be considered the proof of address. Max. file Size = 5 MB. File should be in jpg, pdf, or png format.
      # @option options [String] :proof_type - The type of document that is provided as address proof
      # @option options [String] :id_number - Unique Identifier for the address proof you have submitted

      # @return [Address] Address
      def create(phone_number_country, number_type, salutation, first_name, last_name, address_line1, address_line2, city, region,
                 postal_code, country_iso, options=nil)
        valid_param?(:phone_number_country, phone_number_country, [String, Symbol], true)
        valid_param?(:number_type, number_type, [String, Symbol], true, ['local', 'national', 'mobile', 'tollfree'])
        valid_param?(:salutation, salutation, [String, Symbol], true, ['Mr', 'Ms'])
        valid_param?(:first_name, first_name, [String, Symbol], true)
        valid_param?(:last_name, last_name, [String, Symbol], true)
        valid_param?(:address_line1, address_line1, [String, Symbol], true)
        valid_param?(:address_line2, address_line2, [String, Symbol], true)
        valid_param?(:city, city, [String, Symbol], true)
        valid_param?(:region, region, [String, Symbol], true)
        valid_param?(:postal_code, postal_code, [String, Symbol], true)
        valid_param?(:country_iso, country_iso, [String, Symbol], true)


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
        }
        return perform_create(params, true) if options.nil?

        valid_param?(:options, options, Hash, true)

        if country_iso == 'ES'
          valid_param?(:fiscal_identification_code, options[:fiscal_identification_code], [String, Symbol], true)
          params[:fiscal_identification_code] = options[:fiscal_identification_code]
        end

        if country_iso == 'DK'
          valid_param?(:street_code, options[:street_code], [String, Symbol], true)
          valid_param?(:municipal_code, options[:municipal_code], [String, Symbol], true)

          params[:street_code] = options[:street_code]
          params[:municipal_code] = options[:municipal_code]
        end

        if options[:proof_type]
          if country_iso == 'ES'
            valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NIF', 'NIE', 'DNI'])
          else
            valid_param?(:proof_type, options[:proof_type], [String, Symbol], false, ['NATIONAL_ID_CARD', 'PASSPORT', 'BUSINESS_REGISTRATION', 'any'])
          end
          params[:proof_type] = options[:proof_type]
        end


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
          # add a check on file size
          file_size = File.size("#{options[:file]}")
          if file_size > 5000000
            raise_invalid_request("Maximum file size can be 5 MB")
          end
          params[:file] = Faraday::UploadIO.new(options[:file], content_type)
        end

        %i[alias fiscal_identification_code street_code municipal_code callback_url id_number]
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

      ##
      # Update an address
      # @param [String] address_id
      # @param [String] file_to_upload
      # @param [Hash] options
      # @option options [String] :salutation - One of Mr or Ms
      # @option options [String] :first_name - First name of the user for whom the address is created
      # @option options [String] :last_name - Last name of the user for whom the address is created
      # @option options [String] :country_iso - Country ISO 2 code
      # @option options [String] :address_line1 - Building name/number
      # @option options [String] :address_line2 - The street name/number of the address
      # @option options [String] :city - The city of the address for which the address proof is created
      # @option options [String] :region - The region of the address for which the address proof is created
      # @option options [String] :postal_code - The postal code of the address that is being created
      # @option options [String] :alias - Alias name of the address
      # @option options [String] :auto_correct_address - If set to true, the address will be auto-corrected by the system if necessary. The param needs to be set to false explicitly so that it is not auto-corrected.
      # @option options [String] :callback_url - The callback URL that gets the result of address creation POSTed to.
      # @return [Address] Address
      def update(address_id, options=nil)
        valid_param?(:address_id, address_id, [String, Symbol], true)
        Address.new(@_client,resource_id: address_id).update(options)
      end

      ##
      # Delete an address
      # @param [String] address_id
      def delete(address_id)
        valid_param?(:address_id, address_id, [String, Symbol], true)
        Address.new(@_client,
                     resource_id: address_id).delete
      end

      def each
        offset = 0
        loop do
          address_list = list(offset: offset)
          address_list[:objects].each { |address| yield address }
          offset += 20
          return unless address_list.length == 20
        end
      end
    end
  end
end
