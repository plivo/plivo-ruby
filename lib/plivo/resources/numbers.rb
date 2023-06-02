module Plivo
  module Resources
    include Plivo::Utils

    class PhoneNumber < Base::Resource
      def initialize(client, options = nil)
        @_name = 'PhoneNumber'
        @_identifier_string = 'number'
        super
      end

      def buy(app_id = nil, verification_info = nil, cnam_lookup = nil)
        params = {}
        params[:app_id] = app_id unless app_id.nil?
        params[:verification_info] = verification_info unless verification_info.nil?
        params[:cnam_lookup] = cnam_lookup unless cnam_lookup.nil?
        perform_action(nil, 'POST', params, true)
      end

      def to_s
        {
          country: @country,
          lata: @lata,
          monthly_rental_rate: @monthly_rental_rate,
          number: @number,
          type: @type,
          prefix: @prefix,
          rate_center: @rate_center,
          region: @region,
          resource_uri: @resource_uri,
          restriction: @restriction,
          restriction_text: @restriction_text,
          setup_rate: @setup_rate,
          sms_enabled: @sms_enabled,
          sms_rate: @sms_rate,
          voice_enabled: @voice_enabled,
          voice_rate: @voice_rate,
          tendlc_campaign_id: @tendlc_campaign_id,
          tendlc_registration_status: @tendlc_registration_status,
          toll_free_sms_verification: @toll_free_sms_verification
        }.to_s
      end
    end

    class PhoneNumberInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'PhoneNumber'
        @_resource_type = PhoneNumber
        @_identifier_string = 'number'
        super
      end

      # @param [String] country_iso The ISO code A2 of the country ( BE for Belgium, DE for Germany, GB for United Kingdom, US for United States etc ). See the Wikipedia site for a list of ISOs for different countries.
      # @param [Hash] options
      # @option options [String] :type The type of number you are looking for. The possible number types are fixed, mobile and tollfree. Defaults to any if this field is not specified. type also accepts the value any, which will search for all 3 number types.
      # @option options [String] :pattern Represents the pattern of the number to be searched. Adding a pattern will search for numbers which start with the country code + pattern. For eg. a pattern of 415 and a country_iso: US will search for numbers starting with 1415.
      # @option options [String] :region This filter is only applicable when the type is fixed. If the type is not provided, it is assumed to be fixed. Region based filtering can be performed with the following terms:
      #                                  - Exact names of the region: You could use region=Frankfurt if you were looking for a number in Frankfurt. Performed if the search term is three or more characters in length.
      # @option options [String] :services Filters out phone numbers according to the services you want from that number. The following values are valid:
      #                                    - voice - If this option is selected, it ensures that the results have voice enabled numbers. These numbers may or may not be SMS enabled.
      #                                    - voice,sms - If this option is selected, it ensures that the results have both voice and sms enabled on the same number.
      #                                    - sms - If this option is selected, it ensures that the results have sms enabled numbers. These numbers may or may not be voice enabled.
      #                                    - By default, numbers that have either voice or sms or both enabled are returned.
      # @option options [String] :lata Numbers can be searched using Local Access and Transport Area {http://en.wikipedia.org/wiki/Local_access_and_transport_area}. This filter is applicable only for country_iso US and CA.
      # @option options [String] :rate_center Numbers can be searched using Rate Center {http://en.wikipedia.org/wiki/Telephone_exchange}. This filter is application only for country_iso US and CA.
      # @option options [String] :city Filter phone number based on the city name. This filter is only applicable when the type is Local
      # @option options [Boolean] :eligible If set to true, lists only those numbers that you are eligible to buy at the moment. To list all numbers, ignore this option.
      # @option options [Int] :limit Used to display the number of results per page. The maximum number of results that can be fetched is 20.
      # @option options [Int] :offset Denotes the number of value items by which the results should be offset. Eg:- If the result contains a 1000 values and limit is set to 10 and offset is set to 705, then values 706 through 715 are displayed in the results. This parameter is also used for pagination of the results.
      def search(country_iso, options = nil)
        valid_param?(:country_iso, country_iso, [String, Symbol], true)
        unless country_iso.length == 2
          raise_invalid_request('country_iso should be of length 2')
        end
        params = { country_iso: country_iso }

        return perform_list(params) if options.nil?

        %i[type pattern region services lata rate_center city].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[offset limit].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 [Integer, Integer], true)
            params[param] = options[param]
          end
        end

        %i[eligible].each do |param|
          if options.key?(param) && valid_param?(param, options[param],
                                                 nil, true, [true, false])
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

      def each(country_iso)
        offset = 0
        loop do
          phone_number_list = search(country_iso, offset: offset)
          phone_number_list[:objects].each { |phone_number| yield phone_number }
          offset += 20
          return unless number_list.length == 20
        end
      end

      def buy(number, app_id = nil, verification_info = nil, cnam_lookup = nil)
        valid_param?(:number, number, [Integer, String, Symbol], true)
        PhoneNumber.new(@_client,
                        resource_id: number).buy(app_id, verification_info, cnam_lookup)
      end
    end

    class Number < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Number'
        @_identifier_string = 'number'
        super
      end

      def update(options = nil)
        valid_param?(:options, options, Hash, true)

        params = {}

        if options.key?(:subaccount) &&
           valid_subaccount?(options[:subaccount], true)
          params[:subaccount] = options[:subaccount]
        end

        %i[alias app_id cnam_lookup].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[verification_info].each do |param|
          if options.key?(param) &&
              valid_param?(param, options[param], Hash, true)
            params[param] = options[param]
          end
        end

        perform_update(params)
      end

      def delete
        perform_delete
      end

      def to_s
        {
          api_id: @api_id,
          added_on: @added_on,
          alias: @alias,
          application: @application,
          carrier: @carrier,
          monthly_rental_rate: @monthly_rental_rate,
          number: @number,
          number_type: @number_type,
          region: @region,
          resource_uri: @resource_uri,
          sms_enabled: @sms_enabled,
          sms_rate: @sms_rate,
          sub_account: @sub_account,
          voice_enabled: @voice_enabled,
          voice_rate: @voice_rate,
          tendlc_campaign_id: @tendlc_campaign_id,
          tendlc_registration_status: @tendlc_registration_status,
          toll_free_sms_verification: @toll_free_sms_verification,
          renewal_date: @renewal_date,
          cnam_lookup: @cnam_lookup
        }.to_s
      end
    end

    class NumberInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Number'
        @_resource_type = Number
        @_identifier_string = 'number'
        super
      end

      # @param [String] number
      def get(number)
        perform_get(number)
      end

      # @param [Hash] options
      # @option options [String] :type The type of number you are filtering. You can filter by local and tollfree numbers. Defaults to a local number.
      # @option options [String|Int] :number_startswith Used to specify the beginning of the number. For example, if the number '24' is specified, the API will fetch only those numbers beginning with '24'.
      # @option options [String] :subaccount Requires the auth_id of the subaccount as input. If this parameter is included in the request, all numbers of the particular subaccount are displayed.
      # @option options [String] :alias This is a name given to the number. The API will fetch only those numbers with the alias specified.
      # @option options [String] :services Filters out phone numbers according to the services you want from that number. The following values are valid:
      #                                    - voice - Returns a list of numbers that provide 'voice' services. Additionally, if the numbers offer both 'voice' and 'sms', they are also listed. Note - This option does not exclusively list those services that provide both voice and sms .
      #                                    - voice,sms - Returns a list of numbers that provide both 'voice' and 'sms' services.
      #                                    - sms - Returns a list of numbers that provide only 'sms' services.
      # @option options [Int] :limit Used to display the number of results per page. The maximum number of results that can be fetched is 20.
      # @option options [Int] :offset Denotes the number of value items by which the results should be offset. Eg:- If the result contains a 1000 values and limit is set to 10 and offset is set to 705, then values 706 through 715 are displayed in the results. This parameter is also used for pagination of the results.
      # @option options [String] :tendlc_campaign_id The 10DLC campaign that the number is currently linked with. You can filter US/CA local numbers linked to a specific campaign.
      # @option options [String] :tendlc_registration_status Indicates the 10DLC registration status of a US/CA local number. The following values are valid:
      #                                     - unregistered - Returns a list of numbers that are not linked to any campaign
      #                                     - processing - Returns a list of numbers that are currently in the process of being linked to respective campaigns.
      #                                     - completed - Returns a list of numbers that are successfully linked to respective campaigns.
      # @option options [String] :toll_free_sms_verification Indicates the toll-free SMS verification status of SMS-enabled US/CA toll-free number. The following values are valid:
      #                                     - unverified - Returns a list of SMS-enabled US/CA toll-free numbers that are not verified.
      #                                     - pending_verification - Returns a list of SMS-enabled US/CA toll-free numbers that are pending verification
      #                                     - verified - Returns a list of SMS-enabled US/CA toll-free numbers that are verified for enhanced outbound SMS limits.
      # @option options [String] :renewal_date Returns phone numbers that will be renewed on the specified date. Format: YYYY-MM-DD
      # @option options [String] :renewal_date__lt Returns phone numbers that will be renewed before the specified date. Format: YYYY-MM-DD
      # @option options [String] :renewal_date__lte Returns phone numbers that will be renewed on or before the specified date. Format: YYYY-MM-DD
      # @option options [String] :renewal_date__gt Returns phone numbers that will be renewed after the specified date. Format: YYYY-MM-DD
      # @option options [String] :renewal_date__gte Returns phone numbers that will be renewed on or after the specified date. Format: YYYY-MM-DD
      # @option options [String] :cnam_lookup The Cnam Lookup Configuration associated with that number. The following values are valid:
      #                                     - enabled - Returns the list of numbers for which Cnam Lookup configuration is enabled
      #                                     - disabled - Returns the list of numbers for which Cnam Lookup configuration is disabled
      def list(options = nil)
        return perform_list if options.nil?

        valid_param?(:options, options, Hash, true)

        params = {}

        %i[number_startswith subaccount alias tendlc_campaign_id tendlc_registration_status toll_free_sms_verification renewal_date renewal_date__lt renewal_date__lte renewal_date__gt renewal_date__gte cnam_lookup].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        if options.key?(:services) &&
           valid_param?(:services, options[:services], [String, Symbol],
                        true, %w[sms voice voice,sms])
          params[:services] = options[:services]
        end

        if options.key?(:type) &&
           valid_param?(:type, options[:type], [String, Symbol],
                        true, %w[local tollfree])
          params[:type] = options[:type]
        end

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

        perform_list(params)
      end

      def each
        offset = 0
        loop do
          number_list = list(offset: offset)
          number_list[:objects].each { |number| yield number }
          offset += 20
          return unless number_list.length == 20
        end
      end

      # @param [Array] numbers An array of numbers that need to be added for the carrier. Make sure that you configure the numbers to point to the sip server @sbc.plivo.com. Eg: If the number you own from your carrier is 18554675486 then the sip address it needs to point to is 18554675486@sbc.plivo.com
      # @param [String] carrier The carrier_id of the IncomingCarrier that the number is associated with. For more information, check our IncomingCarrier API {https://www.plivo.com/docs/api/incomingcarrier/}
      # @param [String] region This is the region that is associated with the Number. You can use it to organize numbers based on the area they are from.
      # @param [Hash] options
      # @option options [String] :number_type This field does not impact the way Plivo uses this number. It is primarily adding more information about your number. You may use this field to categorize between local and tollfree numbers. Default is local.
      # @option options [String] :app_id The application id of the application that is to be linked.
      # @option options [String] :subaccount The auth_id of the subaccount to which this number should be added. This can only be performed by a main account holder.
      def add_number(numbers, carrier, region, options = nil)
        valid_param?(:carrier, carrier, [String, Symbol], true)
        valid_param?(:region, region, [String, Symbol], true)
        valid_param?(:numbers, numbers, Array, true)
        numbers.each do |number|
          valid_param?(:number, number, [Integer, String, Symbol], true)
        end

        params = {
          numbers: numbers.join(','),
          carrier: carrier,
          region: region
        }

        return perform_post(params) if options.nil?

        if options.key?(:subaccount) &&
           valid_subaccount?(options[:subaccount], true)
          params[:subaccount] = options[:subaccount]
        end

        %i[number_type app_id].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        perform_post(params)
      end

      # @param [String] number
      # @param [Hash] options
      # @option options [String] :alias The textual name given to the number.
      # @option options [String] :app_id The application id of the application that is to be linked.
      # @option options [String] :subaccount The auth_id of the subaccount to which this number should be added. This can only be performed by a main account holder.
      # @option options [String] :cnam_lookup The Cnam Lookup configuration to enable/disable Cnam Lookup
      def update(number, options = nil)
        valid_param?(:number, number, [String, Symbol], true)
        Number.new(@_client,
                   resource_id: number).update(options)
      end

      # @param [String] number
      def delete(number)
        valid_param?(:number, number, [String, Symbol], true)
        Number.new(@_client, resource_id: number).delete
      end
    end
  end
end
