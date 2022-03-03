#
# Example for Call Create
#
require 'rubygems'
require 'plivo'

include Plivo
include Plivo::Exceptions

api = RestClient.new("MAZTE2MZKXYZEZNJUZZJ","NzczOTEwY2NjNjg3ODYzZmJjODc4ZjgzYTkwNjBj")

begin
  response = api.calls.create(
    '+14151234567',
    ['sip:ajay6121801985815245533110@phone.plivo.com'],
    'https://s3.amazonaws.com/static.plivo.com/answer.xml'
  )
  puts response
rescue PlivoRESTError => e
  puts 'Exception: ' + e.message
end