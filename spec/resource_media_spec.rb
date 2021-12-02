require 'rspec'

describe 'Media test' do
    def to_json_list(list_object)
        objects_json = list_object['objects'].map do |object|
          JSON.parse(lst_to_json(object))
        end
        {
          api_id: list_object['api_id'],
          meta: list_object['meta'],
          objects: objects_json
        }.to_json
      end
      def lst_to_json(media)
        {
          content_type: media['content_type'],
          file_name: media['file_name'],
          media_id: media['media_id'],
          size: media['size'],
          upload_time: media['upload_time'],
          url: media['url']
        }.reject { |_, v| v.nil? }.to_json
      end
      def to_json(obj)
        {
          content_type: obj.content_type,
          file_name: obj.file_name,
          media_id: obj.media_id,
          size: obj.size,
          upload_time: obj.upload_time,
          url: obj.url,
          api_id: obj.api_id
        }.reject { |_, v| v.nil? }.to_json
      end
      
      it 'lists all media' do
        contents = File.read(Dir.pwd + '/spec/mocks/mediaListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.media
                                    .list(
                                      offset: 4
                                    ))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Media/',
                         method: 'GET',
                         data: {
                           offset: 4
                         })
      end
      it 'fetches details of a media' do
        contents = File.read(Dir.pwd + '/spec/mocks/mediaGetResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.media
                       .get(
                         '98854bc5-ea05-4837-a301-0272523e6156'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Media/'\
                         '98854bc5-ea05-4837-a301-0272523e6156/',
                         method: 'GET',
                         data: nil)
        expect(response.media_id).to eql(response.media_id)
      end

end
