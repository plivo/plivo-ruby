module Plivo
  module Resources
    include Plivo::Utils
    class Message < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Message'
        @_identifier_string = 'message_uuid'
        super
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
          units: @units
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
      # @option options [String] :type The type of message. Should be `sms` for a text message. Defaults to `sms`.
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
      def create(src, dst, text, options = nil, powerpack_uuid = nil)
        valid_param?(:src, src, [Integer, String, Symbol], false)
        valid_param?(:text, text, [String, Symbol], true)
        valid_param?(:dst, dst, Array, true)
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
          dst: dst.join('<'),
          text: text,
          powerpack_uuid: powerpack_uuid
        }

        return perform_create(params) if options.nil?
        valid_param?(:options, options, Hash, true)

        if options.key?(:type) &&
           valid_param?(:type, options[:type], String, true, 'sms')
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

        if options.key?(:log) &&
           valid_param?(:log, options[:log], [TrueClass, FalseClass], true)
          params[:log] = options[:log]
        end

        if options.key?(:trackable) &&
          valid_param?(:trackable, options[:trackable], [TrueClass, FalseClass], true)
         params[:trackable] = options[:trackable]
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
      def list(options = nil)
        return perform_list if options.nil?
        valid_param?(:options, options, Hash, true)

        params = {}
        params_expected = %i[
          subaccount message_time message_time__gt message_time__gte
          message_time__lt message_time__lte error_code
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
