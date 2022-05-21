require 'rubygems'
require 'plivo'

include Plivo
#able to identify the number of units, total character and encoding type
#function get_unit_count_encoding takes input string param, example:message content
begin
  text = "❤aabbbb"
  units, count, encoding_type = Utils.get_unit_count_encoding(text)
  puts units
end