require 'rubygems'
require "/usr/src/app/lib/plivo.rb"

include Plivo
include Plivo::Exceptions

api = RestClient.new("MAYJLIZGQ5MWVKZWM4NZ","MjFkZjQ3MzhiODFlZmY4MjIyODk2NTgxOGVmMDdm")

begin
  response = api.tollfree_verifications.get('871f1ec4-5280-44ad-6c9c-82478a646e03')
      puts response
rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
end


begin
  response = api.tollfree_verifications.create('18773582986', '2FA', 'dasas', 'd5a9c4d4-d086-42db-940f-e798d480d064', 'VERBAL', 'https://www.aa.com,http://google.com', '100', 'qwqwq')
      puts response
rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
end

begin
response = api.tollfree_verifications.update('871f1ec4-5280-44ad-6c9c-82478a646e03', usecase: '2FA')
    puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end


begin
response = api.tollfree_verifications.delete('871f1ec4-5280-44ad-6c9c-82478a646e03')
    puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end
