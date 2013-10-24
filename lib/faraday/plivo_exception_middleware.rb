
module Faraday
  class PlivoExceptionMiddleware < Response::RaiseError

    # over-ride the exception middleware for 400 errors
    def on_complete(env)
      case env[:status]
      when 400...600
        raise Plivo::ClientError, response_values(env)
      else
        super
      end
    end
  end
end

Faraday.register_middleware :response, :plivo_exception => Faraday::PlivoExceptionMiddleware