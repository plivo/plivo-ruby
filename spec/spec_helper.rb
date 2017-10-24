require 'simplecov'
SimpleCov.start
require 'bundler/setup'
require 'plivo'

RSpec.configure do |config|
  config.before(:each) do
    @api = Plivo::RestClient.new('MAXXXXXXXXXXXXXXXXXX', 'MjEyOWU5MGVlM2NjZDY1ZTNmZTU2NjZhZGNjMTc5')

    def @api.send_request(uri, method, data = nil)
      # puts "Resource URI: #{uri}"
      # puts "Method: #{method}"
      # puts "Data: #{data}"
      $request = {
        uri: uri,
        method: method,
        data: data
      }
      process_response(method,
                       status: $status,
                       body: $response)
    end

    def mock(status, response)
      $status = status
      $response = response
    end

    def compare_requests(request)
      raise "expected: #{request[:uri]}\ngot: #{$request[:uri]}" unless request[:uri] == $request[:uri]
      raise "expected: #{request[:method]}\ngot: #{$request[:method]}" unless request[:method] == $request[:method]
      raise "expected: #{request[:data]}\ngot: #{$request[:data]}" unless request[:data] == $request[:data]
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
