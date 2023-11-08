require 'rubygems'
require "plivo"

include Plivo
include Plivo::Exceptions

AUTH_ID = 'AUTH_ID'
AUTH_TOKEN = 'AUTH_TOKEN'

api = RestClient.new(AUTH_ID, AUTH_TOKEN)

begin
  response = api.tollfree_verifications.get('uuid')
      puts response
rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
end


begin
  response = api.tollfree_verifications.create('18773582986', '2FA', 'dasas', 
    'd5a9c4d4-d086-42db-940f-e798d480d064', 'VERBAL', 'https://www.aa.com,http://google.com', 
    '100', 'qwqwq')
      puts response
rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
end

begin
response = api.tollfree_verifications.update('uuid', usecase: '2FA')
    puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


begin
response = api.tollfree_verifications.delete('uuid')
    puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end
