module Plivo
  module Resources
    include Plivo::Utils
    class Message < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Message'
        @_identifier_string = 'message_uuid'
        super
      end
      def listMedia()
        perform_action_apiresponse('Media', 'GET') 
      end
      
      def deleteMedia()
        perform_action_apiresponse('Media', 'DELETE') 
      end

      def to_s
        {
          api_id: @api_id,
          error_code: @error_code,
          from_number: @from_number,
          message_direction: @message_direction,
          message_state: @message_state,
          message_time: @message_time,
          message_type: @message_type,
          message_uuid: @message_uuid,
          resource_uri: @resource_uri,
          to_number: @to_number,
          total_amount: @total_amount,
          total_rate: @total_rate,
          powerpack_id: @powerpack_id,
          units: @units,
          tendlc_campaign_id: @tendlc_campaign_id,
          destination_country_iso2: @destination_country_iso2,
          tendlc_registration_status: @tendlc_registration_status,
          requester_ip: @requester_ip,
          is_domestic: @is_domestic,
          replaced_sender: @replaced_sender,
          dlt_entity_id: @dlt_entity_id,
          dlt_template_id: @dlt_template_id,
          dlt_template_category: @dlt_template_category,
          destination_network: @destination_network,
          carrier_fees_rate: @carrier_fees_rate,
          carrier_fees: @carrier_fees
        }.to_s
      end
    end

    class MessagesInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Message'
        @_resource_type = Message
        @_identifier_string = 'message_uuid'
        super
      end

      # @param [String] message_uuid
      def get(message_uuid)
        perform_get(message_uuid)
      end

      # @param [String] src
      # @param [Array] dst
      # @param [String] text
      # @param [Hash] options
      # @option options [String] :type The type of message. Should be `sms` or `mms`. Defaults to `sms`.
      # @option options [String] :url The URL to which with the status of the message is sent. The following parameters are sent to the URL:
      #                               - To - Phone number of the recipient
      #                               - From - Phone number of the sender
      #                               - Status - Status of the message including "queued", "sent", "failed", "delivered", "undelivered" or "rejected"
      #                               - MessageUUID - The unique ID for the message
      #                               - ParentMessageUUID - ID of the parent message (see notes about long SMS below)
      #                               - PartInfo - Specifies the sequence of the message (useful for long messages split into multiple text messages; see notes about long SMS below)
      #                               - TotalRate - Total rate per sms
      #                               - TotalAmount - Total cost of sending the sms (TotalRate * Units)
      #                               - Units - Number of units into which a long SMS was split
      #                               - MCC - Mobile Country Code (see here {https://en.wikipedia.org/wiki/Mobile_country_code} for more details)
      #                               - MNC - Mobile Network Code (see here {https://en.wikipedia.org/wiki/Mobile_country_code} for more details)
      #                               - ErrorCode - Delivery Response code returned by the carrier attempting the delivery. See Supported error codes {https://www.plivo.com/docs/api/message/#standard-plivo-error-codes}.
      # @option options [String] :method The method used to call the url. Defaults to POST.
      # @option options [String] :log If set to false, the content of this message will not be logged on the Plivo infrastructure and the dst value will be masked (e.g., 141XXXXX528). Default is set to true.
      # @option options [String] :trackable set to false
      # @option options[Int]: message_expiry, int value
      # @option options[List]: media_urls Minimum one media url should be present in Media urls list to send mms. Maximum allowd 10 media urls inside the list (e.g, media_urls : ['https//example.com/test.jpg', 'https://example.com/abcd.gif'])
      # @option options[List]: media_ids Minimum one media ids should be present in Media ids list to send mms. Maximum allowd 10 media ids inside the list (e.g, media_ids : ['1fs211ba-355b-11ea-bbc9-02121c1190q7'])
      # @option options [String] :dlt_entity_id This is the DLT entity id passed in the message request.
      # @option options [String] :dlt_template_id This is the DLT template id passed in the message request. 
      # @option options [String] :dlt_template_category This is the DLT template category passed in the message request.
      
      def create(src = nil, dst = nil, text = nil, options = nil, powerpack_uuid = nil)
        #All params in One HASH
        value = src
        if(value.is_a?(Hash))
          valid_param?(:src, value[:src], [Integer, String, Symbol], false)
          valid_param?(:text, value[:text], [String, Symbol], true)
          valid_param?(:dst, value[:dst], [String, Array], true)
          valid_param?(:powerpack_uuid, value[:powerpack_uuid], [String, Symbol], false)

          if (value[:dst] == value[:src])
            raise InvalidRequestError, 'src and dst cannot be same'
          end

          if value.key?(:value).nil? && value.key(:powerpack_uuid).nil?
            raise InvalidRequestError, 'value and powerpack uuid both cannot be nil'
          end

          if !value.key?(:value).nil? && !value.key(:powerpack_uuid).nil?
            raise InvalidRequestError, 'value and powerpack uuid both cannot be present'
          end

          if !value.key?(:dst).nil? && !value.key(:powerpack_uuid).nil?
            raise InvalidRequestError, 'dst is a required parameter'
          end

          params = {
            src: value[:src],
            text: value[:text],
            powerpack_uuid: value[:powerpack_uuid]
          }
          if (value[:dst].is_a?(Array))
            value[:dst].each do |dst_num|
               valid_param?(:dst_num, dst_num, [Integer, String, Symbol], true)
               params[:dst] = value[:dst].join('<')
            end
          else
            params[:dst] = value[:dst]
          end

          #Handling optional params in One HASH
          if value.key?(:type) && valid_param?(:type, value[:type],String, true, %w[sms mms])
            params[:type] = value[:type]
          end

          if value.key?(:url) && valid_param?(:url, value[:url], String, true)
             params[:url] = value[:url]
             if value.key?(:method) &&
              valid_param?(:method, value[:method], String, true, %w[POST GET])
              params[:method] = value[:method]
             else
               params[:method] = 'POST'
             end
          end         
          
          if value.key?(:log) &&
            valid_param?(:log, value[:log], [TrueClass, FalseClass], true)
              params[:log] = value[:log]
          end

          if value.key?(:message_expiry) &&
            valid_param?(:message_expiry, value[:message_expiry], [Integer, Integer], true)
              params[:message_expiry] = value[:message_expiry]
          end         

          if value.key?(:trackable) &&
              valid_param?(:trackable, value[:trackable], [TrueClass, FalseClass], true)
              params[:trackable] = value[:trackable]
          end

          if value.key?(:media_urls) &&
            valid_param?(:media_urls, value[:media_urls], Array, true)
           params[:media_urls] = value[:media_urls]
          end

          if value.key?(:media_ids) &&
            valid_param?(:media_ids, value[:media_ids], Array, true)
           params[:media_ids] = value[:media_ids]
          end

          if value.key?(:dlt_entity_id) &&
            valid_param?(:dlt_entity_id, value[:dlt_entity_id], String, true)
           params[:dlt_entity_id] = value[:dlt_entity_id]
          end

          if value.key?(:dlt_template_id) &&
            valid_param?(:dlt_template_id, value[:dlt_template_id], String, true)
           params[:dlt_template_id] = value[:dlt_template_id]
          end

          if value.key?(:dlt_template_category) &&
            valid_param?(:dlt_template_category, value[:dlt_template_category], String, true)
           params[:dlt_template_category] = value[:dlt_template_category]
          end

        #legacy code compatibility
        else
          valid_param?(:src, src, [Integer, String, Symbol], false)
          valid_param?(:text, text, [String, Symbol], true)
          valid_param?(:dst, dst, [String, Array], true)
          valid_param?(:powerpack_uuid, powerpack_uuid, [String, Symbol], false)
          dst.each do |dst_num|
            valid_param?(:dst_num, dst_num, [Integer, String, Symbol], true)
          end
  
          if dst.include? src
            raise InvalidRequestError, 'src and dst cannot be same'
          end

          if src.nil? && powerpack_uuid.nil?
            raise InvalidRequestError, 'src and powerpack uuid both cannot be nil'
          end

          if !src.nil? && !powerpack_uuid.nil?
            raise InvalidRequestError, 'src and powerpack uuid both cannot be present'
          end

          params = {
            src: src,
            text: text,
            powerpack_uuid: powerpack_uuid
          }

          if (dst.is_a?(Array))
            dst.each do |dst_num|
              valid_param?(:dst_num, dst_num, [Integer, String, Symbol], true)
              params[:dst] = dst.join('<')
            end
          else
            params[:dst] = dst
          end

          return perform_create(params) if options.nil?
          valid_param?(:options, options, Hash, true)

          if options.key?(:type) &&
             valid_param?(:type, options[:type], String, true, %w[sms mms])
            params[:type] = options[:type]
          end

          if options.key?(:url) && valid_param?(:url, options[:url], String, true)
            params[:url] = options[:url]
            if options.key?(:method) &&
               valid_param?(:method, options[:method], String, true, %w[POST GET])
              params[:method] = options[:method]
            else
              params[:method] = 'POST'
            end
          end

          if options.key?(:media_urls) &&
            valid_param?(:media_urls, options[:media_urls], Array, true)
           params[:media_urls] = options[:media_urls]
          end
          
          if options.key?(:media_ids) &&
            valid_param?(:media_ids, options[:media_ids], Array, true)
           params[:media_ids] = options[:media_ids]
          end

          if options.key?(:log) &&
             valid_param?(:log, options[:log], [TrueClass, FalseClass], true)
            params[:log] = options[:log]
          end

          if options.key?(:media_urls) &&
            valid_param?(:media_urls, options[:media_urls], Array, true)
           params[:media_urls] = options[:media_urls]
          end
  
          if options.key?(:media_ids) &&
            valid_param?(:media_ids, options[:media_ids], Array, true)
           params[:media_ids] = options[:media_ids]
          end

          if options.key?(:message_expiry) &&
            valid_param?(:message_expiry, options[:message_expiry], [Integer, Integer], true)
              params[:message_expiry] = options[:message_expiry]
          end

          if options.key?(:trackable) &&
            valid_param?(:trackable, options[:trackable], [TrueClass, FalseClass], true)
           params[:trackable] = options[:trackable]
          end

          if options.key?(:dlt_entity_id) &&
            valid_param?(:dlt_entity_id, options[:dlt_entity_id], String, true)
           params[:dlt_entity_id] = options[:dlt_entity_id]
          end

          if options.key?(:dlt_template_id) &&
            valid_param?(:dlt_template_id, options[:dlt_template_id], String, true)
           params[:dlt_template_id] = options[:dlt_template_id]
          end

          if options.key?(:dlt_template_category) &&
            valid_param?(:dlt_template_category, options[:dlt_template_category], String, true)
           params[:dlt_template_category] = options[:dlt_template_category]
          end
        end
        perform_create(params)
      end

      # @param [Hash] options
      # @option options [String] :subaccount The id of the subaccount, if message details of the subaccount is needed.
      # @option options [String] :message_direction Filter the results by message direction. The valid inputs are inbound and outbound.
      # @option options [String] :message_time Filter out messages according to the time of completion. The filter can be used in the following five forms:
      #                                        - message_time: The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all messages that were sent/received at 2012-03-21 11:47[:30], use message_time=2012-03-21 11:47[:30]
      #                                        - message_time\__gt: gt stands for greater than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all messages that were sent/received after 2012-03-21 11:47, use message_time\__gt=2012-03-21 11:47
      #                                        - message_time\__gte: gte stands for greater than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all messages that were sent/received after or exactly at 2012-03-21 11:47[:30], use message_time\__gte=2012-03-21 11:47[:30]
      #                                        - message_time\__lt: lt stands for lesser than. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all messages that were sent/received before 2012-03-21 11:47, use message_time\__lt=2012-03-21 11:47
      #                                        - message_time\__lte: lte stands for lesser than or equal. The format expected is YYYY-MM-DD HH:MM[:ss[.uuuuuu]]. Eg:- To get all messages that were sent/received before or exactly at 2012-03-21 11:47[:30], use message_time\__lte=2012-03-21 11:47[:30]
      #                                        - Note: The above filters can be combined to get messages that were sent/received in a particular time range. The timestamps need to be UTC timestamps.
      # @option options [String] :message_state Status value of the message, is one of "queued", "sent", "failed", "delivered", "undelivered" or "rejected"
      # @option options [Int] :limit Used to display the number of results per page. The maximum number of results that can be fetched is 20.
      # @option options [Int] :offset Denotes the number of value items by which the results should be offset. Eg:- If the result contains a 1000 values and limit is set to 10 and offset is set to 705, then values 706 through 715 are displayed in the results. This parameter is also used for pagination of the results.
      # @option options [String] :error_code Delivery Response code returned by the carrier attempting the delivery. See Supported error codes {https://www.plivo.com/docs/api/message/#standard-plivo-error-codes}.
      # @option options[List]: media_urls Minimum one media url should be present in Media urls list to send mms. Maximum allowd 10 media urls inside the list (e.g, media_urls : ['https//example.com/test.jpg', 'https://example.com/abcd.gif'])
      # @option options[List]: media_ids Minimum one media ids should be present in Media ids list to send mms. Maximum allowd 10 media ids inside the list (e.g, media_ids : ['1fs211ba-355b-11ea-bbc9-02121c1190q7'])
      # @option options [String] :powerpack_id Filter the results by powerpack id
      # @option options [string]:  tendlc_campaign_id - exact tendlc campaign id search
      # @option options [string]:destination_country_iso2 - valid 2 character country_iso2
      # @option options [string] : tendlc_registration_status - registered or unregistered enum allowed
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[
          subaccount message_time message_time__gt message_time__gte
          message_time__lt message_time__lte error_code powerpack_id tendlc_campaign_id tendlc_registration_status destination_country_iso2
        ]
        params_expected.each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [String, Symbol], true)
            params[param] = options[param]
          end
        end

        %i[offset limit].each do |param|
          if options.key?(param) &&
             valid_param?(param, options[param], [Integer, Integer], true)
            params[param] = options[param]
          end
        end

        if options.key?(:message_direction) &&
           valid_param?(:message_direction, options[:message_direction],
                        [String, Symbol], true, %w[inbound outbound])
          params[:message_direction] = options[:message_direction]
        end

        if options.key?(:message_state) &&
           valid_param?(:message_state, options[:message_state],
                        [String, Symbol], true, %w[queued sent failed delivered
                                                   undelivered rejected])
          params[:message_state] = options[:message_state]
        end

        if options.key?(:limit) &&
           (options[:limit] > 20 || options[:limit] <= 0)
          raise_invalid_request('The maximum number of results that can be '\
          "fetched is 20. limit can't be more than 20 or less than 1")
        end

        raise_invalid_request("Offset can't be negative") if options.key?(:offset) && options[:offset] < 0

        perform_list(params)
      end

      def each
        offset = 0
        loop do
          message_list = list(offset: offset)
          message_list[:objects].each { |message| yield message }
          offset += 20
          return unless message_list.length == 20
        end
      end
    end
  end
end
