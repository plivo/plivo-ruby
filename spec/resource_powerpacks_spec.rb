require 'rspec'

describe 'Powerpack test' do
    def to_json_list(list_object)
        objects_json = list_object[:objects].map do |object|
          JSON.parse(to_json(object))
        end
        {
          api_id: list_object[:api_id],
          meta: list_object[:meta],
          objects: objects_json
        }.to_json
      end

      it 'lists all powerpack' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackListResponse.json')
        mock(200, JSON.parse(contents))
        response = to_json_list(@api.powerpacks
                                    .list(
                                      offset: 2
                                    ))
    
        contents = JSON.parse(contents)
    
        expect(JSON.parse(response))
          .to eql(contents)
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Powerpack/',
                         method: 'GET',
                         data: {
                           offset: 4
                         })
      end
      it 'fetches details of a powerpack' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Powerpack/'\
                         '86bbb125-97bb-4d72-89fd-81d5c515b015/',
                         method: 'GET',
                         data: nil)
        expect(response.id).to eql(response.uuid)
      end

      it 'delete powerpack' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackDeleteResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.powerpacks
                       .delete(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        expect(JSON.parse(to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Powerpack/'\
                         '86bbb125-97bb-4d72-89fd-81d5c515b015/',
                         method: 'DELETE',
                         data: nil)
        expect(response.message).to eql(response.message)
      end

      

end
