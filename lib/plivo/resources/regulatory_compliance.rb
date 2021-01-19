module Plivo
  module Resources
    include Plivo::Utils

    class EndUser < Base::Resource
      def initialize(client, options = nil)
        @_name = 'EndUser'
        @_identifier_string = 'end_user'
        super
      end

      def update(options = nil)
        return perform_update({}) if options.nil?

        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[ name last_name ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        if options.key?(:end_user_type) &&
          valid_param?(:end_user_type, options[:end_user_type].capitalize,[String, Symbol], false,  %w[Business Individual])
          params[:end_user_type] = options[:end_user_type].capitalize
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      def to_s
        {
          api_id: @api_id,
          end_user_id: @end_user_id,
          end_user_type: @end_user_type,
          name: @name,
          last_name: @last_name,
          created_at: @created_at
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end

    class EndUsersInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'EndUser'
        @_resource_type = EndUser
        @_identifier_string = 'end_user'
        super
      end

      ##
      # Get an EndUser
      # @param [String] end_user_id
      # return [EndUser]
      def get(end_user_id)
        valid_param?(:end_user_id, end_user_id, [String, Symbol], true)
        perform_get(end_user_id)
      end

      ##
      # List all EndUser
      # @param [Hash] options
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[ name last_name ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        if options.key?(:end_user_type) &&
          valid_param?(:end_user_type, options[:end_user_type].capitalize,[String, Symbol], false,  %w[Business Individual])
          params[:end_user_type] = options[:end_user_type].capitalize
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer], true)
            params[param] = options[param]
          end
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        perform_list(params)
      end

      ##
      # Create an EndUser
      # @param [String] name
      # @param [String] last_name
      # @param [String] end_user_type
      # return [EndUser] EndUser
      def create(name, last_name = nil , end_user_type)
        valid_param?(:name, name, [String, Symbol], true)
        valid_param?(:last_name, last_name, [String, Symbol], false)
        valid_param?(:end_user_type, end_user_type.capitalize, [String, Symbol], true, %w[Business Individual])

        params = {
          name: name,
          last_name: last_name,
          end_user_type: end_user_type.capitalize
        }

        return perform_create(params)
      end

      ##
      # Update an EndUser
      # @param [String] end_user_id
      # @param [Hash] options
      # return [EndUser]
      def update(end_user_id, options = nil)
        valid_param?(:end_user_id, end_user_id, [String, Symbol], true)
        EndUser.new(@_client,
                        resource_id: end_user_id).update(options)
      end

      ##
      # Delete an EndUser.
      # @param [String] end_user_id
      def delete(end_user_id)
        valid_param?(:end_user_id, end_user_id, [String, Symbol], true)
        EndUser.new(@_client,
                        resource_id: end_user_id).delete
      end
    end

    class ComplianceDocumentType < Base::Resource
      def initialize(client, options = nil)
        @_name = 'ComplianceDocumentType'
        @_identifier_string = 'compliance_document_type'
        super
      end

      def to_s
        {
          api_id: @api_id,
          document_type_id: @document_type_id,
          document_name: @document_name,
          description: @description,
          information: @information,
          proof_required: @proof_required,
          created_at: @created_at
        }.delete_if { |key, value| key==:api_id && value.nil? }.to_s
      end
    end

    class ComplianceDocumentTypesInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'ComplianceDocumentType'
        @_resource_type = ComplianceDocumentType
        @_identifier_string = 'compliance_document_type'
        super
      end

      # Get a ComplianceDocumentType
      # @param [String] document_type_id
      # @return [ComplianceDocumentType] ComplianceDocumentType
      def get(document_type_id)
        valid_param?(:document_type_id, document_type_id, [String, Symbol], true)
        perform_get(document_type_id)
      end

      ##
      # List all ComplianceDocumentTypes
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, false)

        params = {}
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

        perform_list(params)
      end
    end

    class ComplianceDocument < Base::Resource
      def initialize(client, options = nil)
        @_name = 'ComplianceDocument'
        @_identifier_string = 'compliance_document'
        super
      end

      def delete
        perform_delete
      end

      def update(params)
        perform_update(params, use_multipart_conn: true)
      end

      def to_s
        {
          api_id: @api_id,
          end_user_id: @end_user_id,
          document_type_id: @document_type_id,
          compliance_document_id: @compliance_document_id,
          document_id: @document_id,
          alias: @alias,
          meta_information: @meta_information,
          file: @file,
          file_name: @file_name,
          created_at: @created_at
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end
  
    class ComplianceDocumentsInterface < Base::ResourceInterface 
      def initialize(client, resource_list_json = nil)
        @_name = 'ComplianceDocument'
        @_resource_type = ComplianceDocument
        @_identifier_string = 'compliance_document'
        super
      end

      # Get a ComplianceDocument
      # @param [String] compliance_document_id
      # @return [ComplianceDocument] ComplianceDocument
      def get(compliance_document_id)
        valid_param?(:compliance_document_id, compliance_document_id, [String, Symbol], true)
        perform_get(compliance_document_id)
      end

      # List all ComplianceDocuments
      # @option options [Hash] :options
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, false)

        params = {}

        params_expected = %i[ end_user_id document_type_id ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        if options.key?(:alias) && valid_param?(:alias, options[:alias],[String, Symbol], false)
          params[:alias] = options[:alias]
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer], true)
            params[param] = options[param]
          end
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        perform_list(params)
      end

      # Create a ComplianceDocument
      # @param [String] end_user_id
      # @param [String] document_type_id
      # @param [String] alias_
      # @param [String] file
      # @param [Hash] options
      # @return [ComplianceDocument] ComplianceDocument
      def create(end_user_id: nil , document_type_id: nil, alias_: nil, file: nil, **options)
        valid_param?(:end_user_id, end_user_id, [String, Symbol], true)
        valid_param?(:document_type_id, document_type_id, [String, Symbol], true)
        valid_param?(:alias, :alias_, [String, Symbol], true)

        params = {
          end_user_id: end_user_id,
          document_type_id: document_type_id,
          alias: alias_
        }

        if !options.nil?
          valid_param?(:options, options, Hash, false) 
          options.each do |key, value|
            if valid_param?(key, value, [String, Symbol], false)
              params[key] = value
            end
          end
        end

        upload(file, params) if !file.nil?

        perform_create(params, use_multipart_conn: true)
      end

      # Update a ComplianceDocument
      # @param [String] compliance_document_id
      # @param [Hash] options
      # return [ComplianceDocument] ComplianceDocument
      def update(compliance_document_id, options = nil)
        valid_param?(:compliance_document_id, compliance_document_id, [String, Symbol], true)
        valid_param?(:options, options, Hash, true) if !options.nil?
        params = {}

        options.each do |key, value|
          params[key] = value
        end

        upload(params[:file], params) if params.key?(:file)

        ComplianceDocument.new(@_client, resource_id: compliance_document_id).update(params)
      end

      # Delete a ComplianceDocument
      # @param [String] compliance_document_id
      def delete(compliance_document_id)
        valid_param?(:compliance_document_id, compliance_document_id, [String, Symbol], true)
        ComplianceDocument.new(@_client, resource_id: compliance_document_id).delete
      end

      private

      def upload(filepath, params)
        file_extension = filepath.split('.')[-1]
  
        content_type = case file_extension
                          when 'jpeg' then 'image/jpeg'
                          when 'jpg' then 'image/jpeg'
                          when 'png' then 'image/png'
                          when 'pdf' then 'application/pdf'
                          else raise_invalid_request("#{file_extension} is not supported for upload")
                        end
  
        params[:file] = Faraday::UploadIO.new(filepath, content_type)
      end
    end

    class ComplianceRequirement < Base::Resource
      def initialize(client, options = nil)
        @_name = 'ComplianceRequirement'
        @_identifier_string = 'compliance_requirement'
        super
      end

      def to_s
        {
          api_id: @api_id,
          compliance_requirement_id: @compliance_requirement_id,
          country_iso2: @country_iso2,
          number_type: @number_type,
          end_user_type: @end_user_type,
          acceptable_document_types: @acceptable_document_types
        }.delete_if { |key, value| value.nil? }.to_s
      end
    end
  
    class ComplianceRequirementsInterface < Base::ResourceInterface 
      def initialize(client, resource_list_json = nil)
        @_name = 'ComplianceRequirement'
        @_resource_type = ComplianceRequirement
        @_identifier_string = 'compliance_requirement'
        super
      end

      # Get a ComplianceRequirement
      # @param [String] compliance_requirement_id
      # @return [ComplianceRequirement] ComplianceRequirement
      def get(compliance_requirement_id)
        valid_param?(:compliance_requirement_id, compliance_requirement_id, [String, Symbol], true)
        perform_get(compliance_requirement_id)
      end

      # List all ComplianceRequirements
      # @option options [String] :country_iso2
      # @option options [String] :number_type
      # @option options [String] :phone_number
      # @option options [String] :end_user_type
      # A combination of country_iso2, number_type, end_user_type OR
      # phone_number, end_user_type can be used to fetch compliance requirements.
      def list(options = nil)
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[ country_iso2 number_type phone_number ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        if options.key?(:end_user_type) &&
          valid_param?(:end_user_type, options[:end_user_type].capitalize, [String, Symbol], false, %w[Business Individual])
          params[:end_user_type] = options[:end_user_type].capitalize
        end

        perform_get_without_identifier(params)
      end
    end

    class ComplianceApplication < Base::Resource
      def initialize(client, options = nil)
        @_name = 'ComplianceApplication'
        @_identifier_string = 'compliance_application'
        super
      end

      def to_s
        {
          api_id: @api_id,
          created_at: @created_at,
          compliance_application_id: @compliance_application_id,
          alias: @alias,
          status: @status,
          end_user_id: @end_user_id,
          end_user_type: @end_user_type,
          country_iso2: @country_iso2,
          number_type: @number_type,
          compliance_requirement_id: @compliance_requirement_id,
          documents: @documents,
        }.delete_if { |key, value| value.nil? }.to_s
      end

      def update(params)
        perform_update(params)
      end

      def delete
        perform_delete
      end
    end
  
    class ComplianceApplicationsInterface < Base::ResourceInterface 
      def initialize(client, resource_list_json = nil)
        @_name = 'ComplianceApplication'
        @_resource_type = ComplianceApplication
        @_identifier_string = 'compliance_application'
        super
      end

      # Get a ComplianceApplication
      # @param [String] compliance_application_id
      # @return [ComplianceApplication] ComplianceApplication
      def get(compliance_application_id)
        valid_param?(:compliance_application_id, compliance_application_id, [String, Symbol], true)
        perform_get(compliance_application_id)
      end

      # List all ComplianceApplications
      # @option options [Hash] :options
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[  end_user_id country_iso2 number_type status ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], false)
            params[param] = options[param]
          end
        end

        if options.key?(:end_user_type) &&
          valid_param?(:end_user_type, options[:end_user_type].capitalize, [String, Symbol], false, %w[Business Individual])
          params[:end_user_type] = options[:end_user_type].capitalize
        end

        if options.key?(:alias) && valid_param?(:alias, options[:alias],[String, Symbol], false)
          params[:alias] = options[:alias]
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer], true)
            params[param] = options[param]
          end
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        if options.key?(:limit) && (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        perform_list(params)
      end

      # Create a ComplianceApplication
      # @param [String] compliance_requirement_id
      # @param [String] end_user_id
      # @param [String] alias_
      # @param [Array] document_ids
      # @param [String] end_user_type
      # @param [String] country_iso2
      # @param [String] number_type
      # @return [ComplianceApplication] ComplianceApplication
      def create(compliance_requirement_id: nil, end_user_id: nil, alias_: nil,
        document_ids: nil,
        end_user_type: nil,
        country_iso2: nil,
        number_type: nil
        )
        valid_param?(:compliance_requirement_id, compliance_requirement_id, [String, Symbol], false)
        valid_param?(:end_user_id, end_user_id, [String, Symbol], false)
        valid_param?(:alias_, alias_, [String, Symbol], false)
        valid_param?(:country_iso2, country_iso2, [String, Symbol], false)
        valid_param?(:number_type, number_type, [String, Symbol], false)
        valid_param?(:document_ids, document_ids, [Array], false)
        if !document_ids.nil?
          document_ids.each do |document_id|
            valid_param?(:document_id, document_id, [String, Symbol], true)
          end
        end

        if !end_user_type.nil?
          end_user_type = end_user_type.downcase
          valid_param?(:end_user_type, end_user_type, [String, Symbol], false, %w[business individual])
        end

        params = {
          compliance_requirement_id: compliance_requirement_id,
          end_user_id: end_user_id,
          end_user_type: end_user_type,
          country_iso2: country_iso2,
          number_type: number_type,
          document_ids: document_ids,
          alias: alias_
        }.delete_if { |key, value| value.nil? }

        perform_create(params, false)
      end

      # Update a ComplianceApplication
      # @param [String] compliance_application_id
      # @param [Array] document_ids
      # @return [ComplianceApplication] ComplianceApplication
      def update(compliance_application_id, document_ids)
        valid_param?(:compliance_application_id, compliance_application_id, [String, Symbol], true)
        valid_param?(:document_ids, document_ids, [Array], true)
        document_ids.each do |document_id|
          valid_param?(:document_id, document_id, [String, Symbol], true)
        end

        params = {
          compliance_application_id: compliance_application_id,
          document_ids: document_ids
        }

        ComplianceApplication.new(@_client,
                        resource_id: compliance_application_id).update(params)
      end

      # Delete a ComplianceApplication
      # @param [String] compliance_application_id
      def delete(compliance_application_id)
        valid_param?(:compliance_application_id, compliance_application_id, [String, Symbol], true)
        ComplianceApplication.new(@_client,
                        resource_id: compliance_application_id).delete
      end

      # Submit a ComplianceApplication
      # @param [String] compliance_application_id
      def submit(compliance_application_id)
        valid_param?(:compliance_application_id, compliance_application_id, [String, Symbol], true)
        perform_submit(compliance_application_id)
      end
    end
  end
end
