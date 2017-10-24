module Plivo
  ##
  # The exceptions module that helps in passing on errors to the user in a better way.
  module Exceptions
    ##
    # This is Plivo's base error and will be raised when there is an unknown
    # error that is not covered by other errors.
    PlivoRESTError = Class.new(StandardError)

    ##
    # This will be raised when A parameter is missing or is invalid while
    # accessing resource.
    ValidationError = Class.new(PlivoRESTError)
    # 'A parameter is missing or is invalid while accessing resource'

    ##
    # This will be raised when there is an an error authenticating the request.
    #
    # It is because there were no authentication credentials found or passed
    # or the auth credentials that were found or passed were incorrect.
    AuthenticationError = Class.new(PlivoRESTError)

    ##
    # This will be raised when one or more parameters passed to Plivo servers
    # is invalid.
    #
    # More specific error message will be displayed wherever possible.
    InvalidRequestError = Class.new(PlivoRESTError)

    ##
    # This will be raised when there is a server error on the Plivo end.
    #
    # This is rarely encountered. You might want to catch this error and
    # retry the request if needed.
    #
    # If retrying doesn't help, please contact https://support.plivo.com
    # immediately.
    PlivoServerError = Class.new(PlivoRESTError)

    ##
    # This will be raised when there is an XML generation error.
    #
    # Usually, the reason why this error is raised will be included.
    PlivoXMLError = Class.new(PlivoRESTError)

    ##
    # This will be raised when there is an authentication error
    ResourceNotFoundError = Class.new(PlivoRESTError)
  end
end
