require 'rspec'

describe 'Powerpack test' do
    def to_json_list(list_object)
        objects_json = list_object[:objects].map do |object|
          JSON.parse(lst_to_json(object))
        end
        {
          api_id: list_object[:api_id],
          meta: list_object[:meta],
          objects: objects_json
        }.to_json
      end
      def lst_to_json(obj)
        {
          application_id: obj.application_id,
          application_type: obj.application_type,
          created_on: obj.created_on,
          local_connect: obj.local_connect,
          name: obj.name,
          number_pool: obj.number_pool,
          sticky_sender: obj.sticky_sender,
          uuid: obj.uuid
        }.reject { |_, v| v.nil? }.to_json
      end
      def tf_to_json_list(list_object)
        objects_json = list_object['objects'].map do |object|
          JSON.parse(number_to_json(object))
        end
        {
          api_id: list_object['api_id'],
          meta: list_object['meta'],
          objects: objects_json
        }.to_json
      end
      def get_to_json(obj)
        {
          api_id:obj.api_id,
          application_id: obj.application_id,
          application_type: obj.application_type,
          created_on: obj.created_on,
          local_connect: obj.local_connect,
          name: obj.name,
          number_pool: obj.number_pool,
          sticky_sender: obj.sticky_sender,
          uuid: obj.uuid
        }.reject { |_, v| v.nil? }.to_json
      end
      def delete_to_json(obj)
        {
          api_id:obj['api_id'],
          response: obj['response']
         }.reject { |_, v| v.nil? }.to_json
      end
      def number_to_json(obj)
        {
        account_phone_number_resource: obj['account_phone_number_resource'],
        added_on: obj['added_on'],
        country_iso2: obj['country_iso2'],
        number: obj['number'],
        number_pool_uuid: obj['number_pool_uuid'],
        type: obj['type']
        }.reject { |_, v| v.nil? }.to_json
      end
      def get_sc_to_json(obj){
        added_on:obj['added_on'],
        country_iso2:obj['country_iso2'],
        number_pool_uuid: obj['number_pool_uuid'],
        shortcode:obj['shortcode']
        }.reject { |_, v| v.nil? }.to_json
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
                           offset: 2
                         })
      end
      it 'fetches details of a powerpack' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        response = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        expect(JSON.parse(get_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Powerpack/'\
                         '86bbb125-97bb-4d72-89fd-81d5c515b015/',
                       method: 'GET',  
                         data: nil)
        expect(response.id).to eql(response.uuid)
      end

      it 'delete powerpack' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackDelete.json')
        mock(200, JSON.parse(contents))
        response = powerpack.delete()
        expect(JSON.parse(delete_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/Powerpack/'\
                         '86bbb125-97bb-4d72-89fd-81d5c515b015//',
                         method: 'DELETE',
                         data: {unrent_numbers: false})
      end

      it 'find shortcode' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/shortcodeResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.find_shortcode('444444')
        # response = powerpack.numberpool.shortcodes.find('14845733594')
        expect(JSON.parse(get_sc_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Shortcode/444444/',
                         method: 'GET',
                         data: nil)
        expect(response['shortcode']).to eql('444444')
      end
      it 'find tollfree' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/tollfreeResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.find_tollfree('18772209942')
        # response = powerpack.numberpool.tollfree.find('14845733594')
        expect(JSON.parse(number_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Tollfree/18772209942/',
                         method: 'GET',
                         data: nil)
        expect(response['number']).to eql('18772209942')
      end
      it 'find numbers' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/numberpoolResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.find_number('15799140348')
        # response = powerpack.numberpool.numbers.find('14845733594')
        expect(JSON.parse(number_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Number/15799140348/',
                         method: 'GET',
                         data: nil)
        expect(response['number']).to eql('15799140348')
      end

      it 'add numbers' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/numberpoolResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.add_number('15799140348')
        # response = powerpack.numberpool.numbers.add('14845733594')
        expect(JSON.parse(number_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Number/15799140348/',
                         method: 'POST',
                         data: nil)
        expect(response['number']).to eql('15799140348')
      end

      it 'add tollfree' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/tollfreeResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.add_tollfree('18772209942')
        # response = powerpack.numberpool.tollfree.add('15799140348')
        expect(JSON.parse(number_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Tollfree/18772209942/',
                         method: 'POST',
                         data: nil)
        expect(response['number']).to eql('18772209942')
      end

      it 'list tollfree' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/tollfreeListResponse.json')
        mock(200, JSON.parse(contents))
        response = powerpack.list_tollfree()
        # response = powerpack.numberpool.tollfree.add('15799140348')
        expect(JSON.parse(tf_to_json_list(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/'\
                         '659c7f88-c819-46e2-8af4-2d8a84249099/Tollfree/',
                         method: 'GET',
                         data: nil)
      end

      it 'remove tollfree' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackDelete.json')
        mock(200, JSON.parse(contents))
        response = powerpack.remove_tollfree('18772209942', true)
        expect(JSON.parse(delete_to_json(response)))
          .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/659c7f88-c819-46e2-8af4-2d8a84249099/Tollfree/18772209942/',
                         method: 'DELETE',
                         data: {unrent:true})
      end

      it 'remove shortcode' do
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackResponse.json')
        mock(200, JSON.parse(contents))
        powerpack = @api.powerpacks
                       .get(
                         '86bbb125-97bb-4d72-89fd-81d5c515b015'
                       )
        contents = File.read(Dir.pwd + '/spec/mocks/powerpackDelete.json')
        mock(200, JSON.parse(contents))
        response = powerpack.remove_shortcode('444444')
        expect(JSON.parse(delete_to_json(response)))
              .to eql(JSON.parse(contents))
        compare_requests(uri: '/v1/Account/MAXXXXXXXXXXXXXXXXXX/NumberPool/659c7f88-c819-46e2-8af4-2d8a84249099/Shortcode/444444/',
                method: 'DELETE',
                data: {unrent:false})
      end

end
