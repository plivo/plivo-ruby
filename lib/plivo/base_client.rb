require 'json'
require 'faraday'
require 'faraday_middleware'

require_relative 'exceptions'
require_relative 'utils'
require_relative 'resources'
require_relative 'base'

module Plivo
  # Core client, used for all API requests
  include Utils
  class BaseClient
    # Base stuff
    attr_reader :headers, :auth_credentials

    def initialize(auth_id = nil, auth_token = nil, proxy_options = nil, timeout=5)
      configure_credentials(auth_id, auth_token)
      configure_proxies(proxy_options)
      configure_timeout(timeout)
      configure_headers
      configure_connection
    end

    def auth_id
      @auth_credentials[:auth_id]
    end

    def process_response(method, response)
      handle_response_exceptions(response)
      if method == 'DELETE'
        if response[:status] != 204
          raise Exceptions::PlivoRESTError, "Resource at #{response[:url]} "\
          'couldn\'t be deleted'
        end
      elsif !([200, 201, 202].include? response[:status])
        raise Exceptions::PlivoRESTError, "Received #{response[:status]} for #{method}"
      end

      response[:body]
    end

    def send_request(resource_path, method = 'GET', data = {}, timeout = nil, use_multipart_conn = false)
      timeout ||= @timeout

      response = case method
                 when 'GET' then send_get(resource_path, data, timeout)
                 when 'POST' then send_post(resource_path, data, timeout, use_multipart_conn)
                 when 'DELETE' then send_delete(resource_path, timeout)
                 else raise_invalid_request("#{method} not supported by Plivo, yet")
                 end

      process_response(method, response.to_hash)
    end
    
    private

    def auth_token
      @auth_credentials[:auth_token]
    end

    def configure_credentials(auth_id, auth_token)
      # Fetches and sets the right credentials
      auth_id ||= ENV['PLIVO_AUTH_ID']
      auth_token ||= ENV['PLIVO_AUTH_TOKEN']

      raise Exceptions::AuthenticationError, 'Couldn\'t find auth credentials' unless
          auth_id && auth_token

      raise Exceptions::AuthenticationError, "Invalid auth_id: '#{auth_id}'" unless
          Utils.valid_account?(auth_id)

      @auth_credentials = {
          auth_id: auth_id,
          auth_token: auth_token
      }
    end

    def configure_proxies(proxy_dict)
      @proxy_hash = nil
      return unless proxy_dict

      @proxy_hash = {
          uri: "#{proxy_dict[:proxy_host]}:#{proxy_dict[:proxy_port]}",
          user: proxy_dict[:proxy_user],
          password: proxy_dict[:proxy_pass]
      }
    end

    def configure_timeout(timeout)
      @timeout = timeout
    end

    def user_agent
      "plivo-ruby/#{Plivo::VERSION} (Ruby #{RUBY_VERSION})"
    end

    def configure_headers
      @headers = {
          'User-Agent' => user_agent,
          'Content-Type' => 'application/json',
          'Accept' => 'application/json'
      }
    end


    def configure_connection
      @conn = Faraday.new(@base_uri) do |faraday|
        faraday.headers = @headers

        # DANGER: Basic auth should always come after headers, else
        # The headers will replace the basic_auth

        faraday.basic_auth(auth_id, auth_token)

        faraday.proxy=@proxy_hash if @proxy_hash
        faraday.response :json, content_type: /\bjson$/
        faraday.adapter Faraday.default_adapter
      end
    end

    def send_get(resource_path, data, timeout)
      response = @conn.get do |req|
        req.url resource_path, data
        req.options.timeout = timeout if timeout
      end
      response
    end

    def send_post(resource_path, data, timeout, use_multipart_conn)
      if use_multipart_conn
        multipart_conn = Faraday.new(@base_uri) do |faraday|
          faraday.headers = {
              'User-Agent' => @headers['User-Agent'],
              'Accept' => @headers['Accept']
          }

          # DANGER: Basic auth should always come after headers, else
          # The headers will replace the basic_auth

          faraday.request :multipart
          faraday.request :url_encoded
          faraday.basic_auth(auth_id, auth_token)

          faraday.proxy=@proxy_hash if @proxy_hash
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end

        response = multipart_conn.post do |req|
          req.url resource_path
          req.options.timeout = timeout if timeout
          req.body = data
        end
      else
        response = @conn.post do |req|
          req.url resource_path
          req.options.timeout = timeout if timeout
          req.body = JSON.generate(data) if data
        end
      end
      response
    end

    def send_delete(resource_path, timeout)
      response = @conn.delete do |req|
        req.url resource_path
        req.options.timeout = timeout if timeout
      end
      response
    end

    def handle_response_exceptions(response)
      exception_mapping = {
          400 => [
              Exceptions::ValidationError,
              'A parameter is missing or is invalid while accessing resource'
          ],
          401 => [
              Exceptions::AuthenticationError,
              'Failed to authenticate while accessing resource'
          ],
          404 => [
              Exceptions::ResourceNotFoundError,
              'Resource not found'
          ],
          405 => [
              Exceptions::InvalidRequestError,
              'HTTP method used is not allowed to access resource'
          ],
          500 => [
              Exceptions::PlivoServerError,
              'A server error occurred while accessing resource'
          ]
      }

      response_json = response[:body]
      return unless exception_mapping.key? response[:status]

      exception_now = exception_mapping[response[:status]]
      error_message = if (response_json.is_a? Hash) && (response_json.key? 'error')
                        response_json['error']
                      else
                        exception_now[1] + " at: #{response[:url]}"
                      end
      if error_message.is_a?(Hash) && error_message.key?('error')
        error_message = error_message['error']
      end

      raise exception_now[0], error_message.to_s
    end
  end
end
