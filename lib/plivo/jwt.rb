# frozen_string_literal: true

require 'openssl'
require 'uri'
require 'base64'
require 'date'
require 'jwt'

module Plivo
  module Token
    include Utils

    class VoiceGrants
      attr_reader :incoming_allow, :outgoing_allow

      def initialize(incoming = nil, outgoing = nil)
        Utils.valid_param?(:incoming, incoming, [TrueClass, FalseClass], false)
        Utils.valid_param?(:outgoing, outgoing, [TrueClass, FalseClass], false)
        @incoming_allow = incoming
        @outgoing_allow = outgoing
      end

      def to_hash
        hash = {}
        instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
        hash
      end
    end

    class AccessToken
      attr_reader :uid, :username, :valid_from, :lifetime, :grants
      def initialize(auth_id = nil, auth_token = nil, username = nil, uid = nil)
        configure_credentials(auth_id, auth_token)
        Utils.valid_param?(:username, username, [String, Symbol], true)
        @username = username

        Utils.valid_param?(:uid, uid, [String, Symbol], false)
        uid ||= username + '-' + Time.now.to_i
        @uid = uid
        update_validity
      end

      def update_validity(valid_from = nil, lifetime = nil, valid_till = nil)
        Utils.valid_param?(:valid_from, valid_from, [Time, Integer], false)
        Utils.valid_param?(:lifetime, lifetime, [Integer], false)
        Utils.valid_param?(:valid_till, valid_till, [Time, Integer], false)

        if valid_from.nil?
          @lifetime = lifetime || 84_600
          @valid_from = if valid_till.nil?
                          Time.now
                        else
                          Time.at(valid_till.to_i - @lifetime).utc
                        end

        elsif valid_till.nil?
          @lifetime = lifetime || 84_600
          @valid_from = valid_from
        else
          unless lifetime.nil?
            raise Exceptions::ValidationError, 'use any 2 of valid_from, lifetime and valid_till'
          end

          @valid_from = valid_from
          @lifetime = valid_till.to_i - valid_from.to_i
        end

        return unless @lifetime < 180 || @lifetime > 84_600

        raise Exceptions::ValidationError, 'validity out of [180, 84600] seconds'
      end

      def auth_id
        @auth_credentials[:auth_id]
      end

      def add_voice_grants(grants)
        Utils.valid_param?(:grants, grants, [VoiceGrants], true)
        @grants = grants
      end

      def to_jwt
        payload = {
          jti: uid,
          sub: username,
          iss: auth_id,
          nbf: valid_from.to_i,
          exp: valid_from.to_i + lifetime,
          grants: {
            voice: grants.to_hash || {}
          }
        }
        JWT.encode payload, key, 'HS256', {typ: 'JWT', cty: 'plivo;v=1'}
      end

      private

      def key
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
    end
  end
end
