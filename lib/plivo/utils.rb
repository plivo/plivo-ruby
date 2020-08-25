require 'openssl'
require 'uri'
require 'base64'

module Plivo
  # Utils module
  module Utils
    module_function

    TYPE_WHITELIST = [Integer]
    TYPE_WHITELIST.push(Fixnum, Bignum) unless 1.class == Integer

    def valid_account?(account_id, raise_directly = false)
      valid_subaccount?(account_id, raise_directly) || valid_mainaccount?(account_id, raise_directly)
    end

    # @param [String] account_id
    # @param [Boolean] raise_directly
    def valid_subaccount?(account_id, raise_directly = false)
      unless account_id.is_a? String
        return false unless raise_directly
        raise_invalid_request('subaccount_id must be a string')
      end

      if account_id.length != 20
        return false unless raise_directly
        raise_invalid_request('subaccount_id should be of length 20')
      end

      if account_id[0..1] != 'SA'
        return false unless raise_directly
        raise_invalid_request("subaccount_id should start with 'SA'")
      end
      true
    end

    def valid_mainaccount?(account_id, raise_directly = false)
      unless account_id.is_a? String
        return false unless raise_directly
        raise_invalid_request('account_id must be a string')
      end

      if account_id.length != 20
        return false unless raise_directly
        raise_invalid_request('account_id should be of length 20')
      end

      if account_id[0..1] != 'MA'
        return false unless raise_directly
        raise_invalid_request("account_id should start with 'SA'")
      end
      true
    end

    def raise_invalid_request(message = '')
      raise Exceptions::InvalidRequestError, message
    end

    def valid_param?(param_name, param_value, expected_types = nil, mandatory = false, expected_values = nil)
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?

      return expected_type?(param_name, expected_types, param_value) unless expected_values
      expected_value?(param_name, expected_values, param_value)
    end

    def valid_multiple_destination_nos?(param_name, param_value, options = nil)
      if param_value.split(options[:delimiter]).size > 1 && options[:role].downcase != 'agent'
        raise_invalid_request("Multiple #{param_name} values given for role #{options[:role]}")
      elsif param_value.split(options[:delimiter]).size >= options[:agent_limit]
        raise_invalid_request("No of #{param_name} values provided should be lesser than #{options[:agent_limit]}")
      else
        return true
      end
    end

    def valid_url?(param_name, param_value, mandatory = false)
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?
      return raise_invalid_request("#{param_name}: Expected a String but received #{param_value.class} instead") unless expected_type?(param_name, String, param_value)

      if param_value =~ /^(http[s]?:\/\/([a-zA-Z]|[0-9]|[\$\-\_\@\.\&\+\/\#]|[\!\*\(\)\,]|(%[0-9a-fA-F][0-9a-fA-F]))+|nil)$/ix
        return true
      else
        return raise_invalid_request("Invalid URL : Doesn't satisfy the URL format")
      end
    end

    def valid_range?(param_name, param_value, mandatory = false, lower_bound = nil, upper_bound = nil)
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?

      return raise_invalid_request("#{param_name}: Expected an Integer but received #{param_value.class} instead") unless expected_type?(param_name, Integer, param_value)
      if lower_bound && upper_bound
        return raise_invalid_request("#{param_name} ranges between #{lower_bound} and #{upper_bound}") if param_value < lower_bound or param_value > upper_bound

        return true if param_value >= lower_bound and param_value <= upper_bound
      elsif lower_bound
        return raise_invalid_request("#{param_name} should be greater than #{lower_bound}") if param_value < lower_bound

        return true if param_value >= lower_bound
      elsif upper_bound
        return raise_invalid_request("#{param_name} should be lesser than #{upper_bound}") if param_value > upper_bound

        return true if param_value <= upper_bound
      else
        return raise_invalid_request("Any one or both of lower and upper bound should be provided")
      end
    end

    def multi_valid_param?(param_name, param_value, expected_types = nil, mandatory = false, expected_values = nil, make_down_case = false, seperator = ',')
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?

      if make_down_case
        param_value = param_value.downcase
      else
        param_value = param_value.uppercase
      end

      for val in param_value.split(seperator)
        return expected_type?(param_name, expected_types, val.strip) unless expected_values
        expected_value?(param_name, expected_values, val.strip)
      end
    end

    def valid_date_format?(param_name, param_value, mandatory = false)
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?

      if param_value =~ /^(\d{4}\-\d{2}\-\d{2}\ \d{2}\:\d{2}(\:\d{2}(\.\d{1,6})?)?)$/ix
        return true
      else
        return raise_invalid_request("Invalid Date Format")
      end
    end

    def is_one_among_string_url?(param_name, param_value, mandatory = false, expected_values= nil)
      if mandatory && param_value.nil?
        raise_invalid_request("#{param_name} is a required parameter")
      end

      return true if param_value.nil?
      return raise_invalid_request("#{param_name}: Expected a String but received #{param_value.class} instead") unless expected_type?(param_name, String, param_value)

      if expected_values.include? param_value.downcase or expected_values.include? param_value.upcase
        return true
      elsif valid_url?(param_name, param_value)
        return true
      else
        raise_invalid_request("#{param_name} neither a valid URL nor in the expected values")
      end
    end

    def expected_type?(param_name, expected_types, param_value)
      return true if expected_types.nil?
      param_value_class = param_value.class
      param_value_class = Integer if TYPE_WHITELIST.include? param_value_class
      if expected_types.is_a? Array
        return true if expected_types.include? param_value_class
        raise_invalid_request("#{param_name}: Expected one of #{expected_types}"\
          " but received #{param_value.class} instead")
      else
        return true if expected_types == param_value_class
        raise_invalid_request("#{param_name}: Expected a #{expected_types}"\
          " but received #{param_value.class} instead")
      end
    end

    def expected_value?(param_name, expected_values, param_value)
      return true if expected_values.nil?
      if expected_values.is_a? Array
        return true if expected_values.include? param_value
        raise_invalid_request("#{param_name}: Expected one of #{expected_values}"\
          " but received '#{param_value}' instead")
      else
        return true if expected_values == param_value
        raise_invalid_request("#{param_name}: Expected '#{expected_values}'"\
          " but received '#{param_value}' instead")
      end
    end

    # @param [String] uri
    # @param [String] nonce
    # @param [String] signature
    # @param [String] auth_token
    def valid_signature?(uri, nonce, signature, auth_token)
      parsed_uri = URI.parse(uri)
      uri_details = {host: parsed_uri.host, path: parsed_uri.path}
      uri_builder_module = parsed_uri.scheme == 'https' ? URI::HTTPS : URI::HTTP
      data_to_sign = uri_builder_module.build(uri_details).to_s + nonce
      sha256_digest = OpenSSL::Digest.new('sha256')
      Base64.encode64(OpenSSL::HMAC.digest(sha256_digest, auth_token, data_to_sign)).strip() == signature
    end

    def generate_url?(uri, params, method)
      uri.sub!("+", "%20")
      parsed_uri = URI.parse(uri)
      uri = parsed_uri.scheme + "://" + parsed_uri.host + parsed_uri.path
      if params.to_s.length > 0 || parsed_uri.query.to_s.length > 0
        uri += "?"
      end
      if parsed_uri.query.to_s.length > 0
        parsed_uri_query = URI.decode(parsed_uri.query)
        if method == "GET"
          queryParamMap = getMapFromQueryString?(parsed_uri_query)
          params.keys.sort.each { |key|
            queryParamMap[key] = params[key]
          }
          uri += GetSortedQueryParamString?(queryParamMap, true)
        else
          uri += GetSortedQueryParamString?(getMapFromQueryString?(parsed_uri_query), true) + "." + GetSortedQueryParamString?(params, false)
          uri = uri.chomp(".")
        end
      else
        if method == "GET"
          uri += GetSortedQueryParamString?(params, true)
        else
          uri += GetSortedQueryParamString?(params, false)
        end
      end
      return uri
    end

    def getMapFromQueryString?(query)
      mp = Hash.new
      if query.to_s.length == 0
        return mp
      end
      keyValuePairs = query.split("&")
      keyValuePairs.each { |key|
        params = key.split("=", 2)
        if params.length == 2
          mp[params[0]] = params[1]
        end
      }
      return mp
    end

    def GetSortedQueryParamString?(params, queryParams)
      url = ""
      if queryParams
        params.keys.sort.each { |key|
          url += key + "=" + params[key] + "&"
        }
        url = url.chomp("&")
      else
        params.keys.sort.each { |key|
          url += key.to_s + params[key].to_s
        }
      end
      return url
    end


    def compute_signatureV3?(url, auth_token, nonce)
      sha256_digest = OpenSSL::Digest.new('sha256')
      new_url = url + "." + nonce
      return Base64.encode64(OpenSSL::HMAC.digest(sha256_digest, auth_token, new_url)).strip()
    end

    def valid_signatureV3?(uri, nonce, signature, auth_token, method, params={})
      new_url = generate_url?(uri, params, method)
      generated_signature = compute_signatureV3?(new_url, auth_token, nonce)
      return signature.split(",").include? generated_signature
    end
  end
end
