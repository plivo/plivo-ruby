module Plivo
  module Resources
    include Plivo::Utils
    class Media < Base::Resource
      def initialize(client, options = nil)
        @_name = 'Media'
        @_identifier_string = 'media_id'
        super
      end

      def to_s
        {
          content_type: @content_type,
          file_name: @file_name,
          api_id: @api_id,
          media_id: @media_id,
          size: @size,
          upload_time: @upload_time,
          url: @url
        }.to_s
      end
    end

    class MediaInterface < Base::ResourceInterface
      def initialize(client, resource_list_json = nil)
        @_name = 'Media'
        @_resource_type = Media
        @_identifier_string = 'media_id'
        super
      end

      ##
      # Get an Media
      # @param [String] media_id
      # @return [Media] Media
      def get(media_id)
        valid_param?(:media_id, media_id, [String, Symbol], true)
        perform_get(media_id)
      end

      ##
      # List all Media
      # @param [Hash] options
      # @option options [Int] :offset
      # @option options [Int] :limit
      # @return [Hash]
      def list(options=nil)
        return perform_list_without_object if options.nil?

        params = {}
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

        perform_list_without_object(params)
      end

      ##
      # Create a new upload
      def upload(filepath)
        params = {}
        for file_to_upload in filepath do
          unless file_to_upload.nil?
          file_extension = file_to_upload.split('.')[-1]

          content_type = case file_extension
                           when 'jpeg' then 'image/jpeg'
                           when 'jpg' then 'image/jpeg'
                           when 'png' then 'image/png'
                           when 'gif' then 'image/gif'
                           when 'mp3' then 'audio/mp3'
                           when 'mp4' then 'video/mp4'
                           when 'mpeg' then 'video/mpeg'
                           when 'wav' then 'audio/wav'
                           when 'ogg' then 'audio/ogg'
                           when '3gpp' then 'video/3gpp'
                           when '3gpp2' then 'video/3gpp2'
                           when 'vcard' then 'text/vcard'
                           when 'csv' then 'text/csv'
                           when 'pdf' then 'application/pdf'
                           when 'xls' then 'application/vnd.ms-excel'
                           when 'xlsx' then 'application/vnd.ms-excel'
                           when 'xcf' then 'image/xcf'
                           when 'text' then 'text/plain'
                           when 'plain' then 'text/plain'
                           else raise_invalid_request("#{file_extension} is not yet supported for upload")
                         end

          params[:file] = Faraday::UploadIO.new(file_to_upload, content_type)
          end
        end
        perform_create(params, true)
      end
    end
  end
end