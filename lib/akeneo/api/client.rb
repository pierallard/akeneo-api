require "akeneo/api/client_endpoint/product"
require "akeneo/api/client_endpoint/family"
require "akeneo/api/client_endpoint/attribute"
require "akeneo/api/client_endpoint/attribute-group"
require "akeneo/api/client_endpoint/locale"
require "akeneo/api/client_endpoint/channel"
require "akeneo/api/client_endpoint/currency"
require 'net/http'
require 'json'

module Akeneo::Api
	class Client
		attr_accessor :uri, :access_token

		def initialize(uri)
			@uri = uri
			@access_token = nil
		end

		def is_authentified?
			return !@access_token.nil?
		end

		def authenticate(token, secret, username, password)
			token_uri = URI("#{@uri}/api/oauth/v1/token")

			query = Net::HTTP::Post.new(token_uri)
			query.content_type = 'application/json'
			query.basic_auth(token, secret)
			query.body = JSON.generate({
				grant_type: 'password',
				username: username,
				password: password
				})

			res = Net::HTTP.start(token_uri.hostname, token_uri.port) do |http|
				http.request(query)
			end

			if (!res.kind_of? Net::HTTPSuccess) then
				raise res.body
			end

			data = JSON.parse(res.body)
			@access_token = data['access_token']

			return self
		end

		def products
			return ClientEndpoint::Product.new(self)
		end

		def families
			return ClientEndpoint::Family.new(self)
		end

		def attributes
			return ClientEndpoint::Attribute.new(self)
		end

		def attribute_groups
			return ClientEndpoint::AttributeGroup.new(self)
		end

		def locales
			return ClientEndpoint::Locale.new(self)
		end

		def channels
			return ClientEndpoint::Channel.new(self)
		end

		def currencies
			return ClientEndpoint::Currency.new(self)
		end
	end
end
