module Plivo
  module Resources
    include Plivo::Utils

    class PhoneNumberComplianceRequirement < Base::Resource
      def initialize(client, options = nil)
        @_name = 'PhoneNumber/Compliance/Requirements'
        @_identifier_string = 'requirement_id'
        super
      end

      def to_s
        {
          api_id: @api_id,
          requirement_id: @requirement_id,
          country_iso: @country_iso,
          number_type: @number_type,
          user_type: @user_type,
          document_types: @document_types
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end

    class PhoneNumberComplianceRequirementsInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'PhoneNumber/Compliance/Requirements'
        @_resource_type = PhoneNumberComplianceRequirement
        @_identifier_string = 'requirement_id'
        super
      end

      ##
      # Get phone number compliance requirements
      # @param [Hash] options
      # @option options [String] :country_iso
      # @option options [String] :number_type
      # @option options [String] :user_type
      # @return [PhoneNumberComplianceRequirement]
      def get(options = nil)
        params = {}
        if options
          valid_param?(:options, options, Hash, true)
          %i[country_iso number_type user_type].each do |param|
            if options.key?(param) &&
               valid_param?(param, options[param], [String, Symbol], false)
              params[param] = options[param]
            end
          end
        end
        perform_get_without_identifier(params)
      end
    end

    class PhoneNumberCompliance < Base::Resource
      def initialize(client, options = nil)
        @_name = 'PhoneNumber/Compliance'
        @_identifier_string = 'compliance_id'
        super
      end

      def update(params)
        unless @id
          raise_invalid_request("Cannot update a #{@_name} resource "\
                                  'without an identifier')
        end

        response_json = @_client.send_request(@_resource_uri, 'PATCH', params, nil, true, is_voice_request: false)
        parse_and_set(response_json)
        self
      end

      def delete
        perform_delete
      end

      def to_s
        {
          api_id: @api_id,
          compliance_id: @compliance_id,
          alias: @alias,
          status: @status,
          country_iso: @country_iso,
          number_type: @number_type,
          user_type: @user_type,
          created_at: @created_at,
          updated_at: @updated_at
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end

    class PhoneNumberCompliancesInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'PhoneNumber/Compliance'
        @_resource_type = PhoneNumberCompliance
        @_identifier_string = 'compliance_id'
        super
      end

      ##
      # Create a phone number compliance application
      # @param [Hash] data_hash - compliance data (country_iso, number_type, alias, end_user, documents, etc.)
      # @param [Array] documents - list of local file paths for document uploads (optional)
      # @return [Response]
      def create(data_hash, documents = nil)
        params = { data: JSON.generate(data_hash) }
        if documents
          documents.each_with_index do |filepath, index|
            file_extension = filepath.split('.')[-1]
            content_type = case file_extension
                           when 'jpeg', 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'pdf' then 'application/pdf'
                           else raise_invalid_request("#{file_extension} is not supported")
                           end
            params["documents[#{index}].file"] = Faraday::UploadIO.new(filepath, content_type)
          end
        end
        perform_create(params, true)
      end

      ##
      # Get a phone number compliance application
      # @param [String] compliance_id
      # @param [Hash] options
      # @option options [String] :expand
      # @return [PhoneNumberCompliance]
      def get(compliance_id, options = nil)
        valid_param?(:compliance_id, compliance_id, [String, Symbol], true)
        params = {}
        if options
          valid_param?(:options, options, Hash, true)
          if options.key?(:expand) &&
             valid_param?(:expand, options[:expand], [String, Symbol], false)
            params[:expand] = options[:expand]
          end
        end
        response_json = @_client.send_request(@_resource_uri + compliance_id.to_s + '/', 'GET', params, nil, false, is_voice_request: false)
        # Extract the compliance wrapper returned by the API
        compliance_data = response_json['compliance'] || response_json
        compliance_data['api_id'] = response_json['api_id'] if response_json['api_id']
        @_resource_type.new(@_client, resource_json: compliance_data)
      end

      ##
      # List phone number compliance applications
      # @param [Hash] options
      # @option options [Int] :limit
      # @option options [Int] :offset
      # @option options [String] :status
      # @option options [String] :country_iso
      # @option options [String] :number_type
      # @option options [String] :user_type
      # @option options [String] :alias
      # @option options [String] :expand
      # @return [Hash]
      def list(options = nil)
        params = {}
        if options
          valid_param?(:options, options, Hash, true)

          %i[status country_iso number_type user_type alias expand].each do |param|
            if options.key?(param) &&
               valid_param?(param, options[param], [String, Symbol], false)
              params[param] = options[param]
            end
          end

          %i[offset limit].each do |param|
            if options.key?(param) && valid_param?(param, options[param],
                                                   [Integer], false)
              params[param] = options[param]
            end
          end

          raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

          if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
            raise_invalid_request('The maximum number of results that can be '\
            "fetched is 20. limit can't be more than 20 or less than 1")
          end
        end

        response_json = @_client.send_request(@_resource_uri, 'GET', params, nil, false, is_voice_request: false)

        # Remap 'compliances' to 'objects' for base class compatibility
        if response_json.key?('compliances')
          response_json['objects'] = response_json.delete('compliances')
        end

        parse_and_set(response_json)
        {
          api_id: @api_id,
          meta: @_meta,
          objects: @_resource_list
        }
      end

      ##
      # Update a phone number compliance application
      # @param [String] compliance_id
      # @param [Hash] data_hash - compliance data to update
      # @param [Array] documents - list of local file paths for document uploads (optional)
      # @return [PhoneNumberCompliance]
      def update(compliance_id, data_hash, documents = nil)
        valid_param?(:compliance_id, compliance_id, [String, Symbol], true)

        params = { data: JSON.generate(data_hash) }
        if documents
          documents.each_with_index do |filepath, index|
            file_extension = filepath.split('.')[-1]
            content_type = case file_extension
                           when 'jpeg', 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'pdf' then 'application/pdf'
                           else raise_invalid_request("#{file_extension} is not supported")
                           end
            params["documents[#{index}].file"] = Faraday::UploadIO.new(filepath, content_type)
          end
        end

        PhoneNumberCompliance.new(@_client,
                        resource_id: compliance_id).update(params)
      end

      ##
      # Delete a phone number compliance application
      # @param [String] compliance_id
      def delete(compliance_id)
        valid_param?(:compliance_id, compliance_id, [String, Symbol], true)
        PhoneNumberCompliance.new(@_client,
                        resource_id: compliance_id).delete
      end
    end

    class PhoneNumberComplianceLinkInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'PhoneNumber/Compliance/Link'
        @_resource_type = PhoneNumberCompliance
        @_identifier_string = 'compliance_id'
        super
      end

      ##
      # Link numbers to compliance applications
      # @param [Array] numbers - list of hashes with 'number' and 'compliance_application_id'
      # @return [Response]
      def create(numbers)
        valid_param?(:numbers, numbers, Array, true)
        params = { numbers: numbers }
        perform_create(params)
      end
    end
  end
end
