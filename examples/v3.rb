require 'plivo'
include Plivo
begin
  @api = Plivo::RestClient.new('MAMDJMMTEZOWY0ZMQWM2', 'OTljNmVmOGVkNGZhNjJlOWIyMWM0ZDI0ZjQwZDdk')
  response = @api.calls
                 .create('+919090909090',
                         ['+918309866821'],
                         'https://plivobin.non-prod.plivops.com/api/v1/Conference_test07.xml',
                         'GET', [:time_limit => 100])
  puts response
  # response1 = @api.conferences.list
  # puts response1
  # response2 = @api.multipartycalls.list
  # puts response2
  # puts response2.object
  # response3 = @api.multipartycalls.get(nil, 'TestMPC15')
  # puts response3
  #
  # response4 = @api.multipartycalls.add_participant('agent','TestMPC15', nil ,'+912333333333','+918309866821')
  # puts response4
  # puts response4.calls
  # response5 = @api.multipartycalls.start(nil, 'TestMPC15')
  # puts response5
  # response6 = @api.multipartycalls.stop(nil, 'TestMPC15')
  # puts response6
  # response7 = @api.multipartycalls.start_recording(nil, 'TestMPC15','mp3','http://plivobin.non-prod.plivops.com/qpj0w5qp','POST')
  # puts response7
  # response8 = @api.multipartycalls.stop_recording(nil, 'TestMPC15')
  # puts response8
  # response9 = @api.multipartycalls.pause_recording(nil, 'TestMPC15')
  # puts response9
  # response10 = @api.multipartycalls.resume_recording(nil, 'TestMPC15')
  # puts response10
  # response11 = @api.multipartycalls.list_participants(nil ,'TestMPC15')
  # puts response11
  # response12 = @api.multipartycalls.update_participant( 165,nil,'TestMPC15',nil ,true,false )
  # puts response12
  # response13 = @api.multipartycalls.kick_participant(165,nil,'TestMPC15')
  # puts response13
  # response14 = @api.multipartycalls.get_participant(170,nil,'TestMPC15')
  # puts response14
  # get_response = @api.conferences.get(conference_name="FStestconference")
  # puts get_response
end