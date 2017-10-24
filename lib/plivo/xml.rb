require 'rexml/document'
require 'htmlentities'

require_relative 'xml/element'
require_relative 'xml/response'
require_relative 'xml/conference'
require_relative 'xml/dial'
require_relative 'xml/dtmf'
require_relative 'xml/get_digits'
require_relative 'xml/hangup'
require_relative 'xml/message'
require_relative 'xml/number'
require_relative 'xml/play'
require_relative 'xml/pre_answer'
require_relative 'xml/record'
require_relative 'xml/redirect'
require_relative 'xml/speak'
require_relative 'xml/user'
require_relative 'xml/wait'
require_relative 'xml/plivo_xml'

include Plivo::Exceptions

module Plivo
  module XML
  end
end
