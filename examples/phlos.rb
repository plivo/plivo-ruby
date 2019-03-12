require 'rubygems'
require 'plivo'

include Plivo

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUTH_TOKEN'

client = Phlo.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Phlo.new
#

# provide the phlo_id in params
begin
  phlo = client.phlo.get('phlo_id')
  puts phlo
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Sample Response:
# {
#   "api_id": '36989807-a76f-4555-84d1-9dfdccca7a80',
#   "phlo_id": 'e564a84a-7910-4447-b16f-65c541dd552c',
#   "name": 'assignment_mpc',
#   "created_on": '2018-11-03 19:32:33.240504+00:00'
# }


# initiate phlo via API request:
begin
  #optional parameter - params
  params = {
     from: '9999999999',
     to: '0000000000'
  }
  response = phlo.run(params)
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


# Sample Response:
# {
#     :api_id=>"ff25223a-1c9f-11e4-80aa-12313f048015",
#     :phlo_id=>"ff25223a-1c9f-11e4-80aa-12313f048015",
#     :name=>"assignment_mpc",
#     :created_on=>"2018-11-03 19:32:33.210714+00:00",
#     :phlo_run_id=>"ff25223a-1c9f-11e4-80aa-12313f048015"
# }
