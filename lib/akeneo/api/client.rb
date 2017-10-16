require "akeneo/api/client_endpoint/product"

module Akeneo::Api
    class Client
        attr_accessor :products, :uri, :access_token

        def initialize(uri)
            @uri = uri
            @access_token = nil
            @products = ClientEndpoint::Product.new(self)
        end

        def is_authentified?
            return !@access_token.nil?
        end

        def authenticate(token, secret, username, password)
            token_uri = URI("#{@uri}/api/oauth/v1/token")

            query = Net::HTTP::Post.new(token_uri)
            query.content_type = 'application/json'
            query.basic_auth(token, secret)
            query.body = {
                grant_type: 'password',
                username: username,
                password: password
            }.to_json

            res = Net::HTTP.start(token_uri.hostname, token_uri.port) do |http|
                http.request(query)
            end

            if (!res.kind_of? Net::HTTPSuccess) then
                raise res.body
            end

            data = JSON.parse(res.body)
            @access_token = data['access_token']
        end
    end
end
