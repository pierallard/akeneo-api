require "akeneo/api/product"

module Akeneo::Api
    class Client
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
            query.body = {
                grant_type: 'password',
                username: username,
                password: password
            }.to_json

            res = Net::HTTP.start(token_uri.hostname, token_uri.port) do |http|
                http.request(query)
            end

            data = JSON.parse(res.body)
            @access_token = data['access_token']
        end

        def product(sku)
            product_uri = URI("#{@uri}/api/rest/v1/products/#{sku}")
            query = Net::HTTP::Get.new(product_uri)
            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @access_token

            res = Net::HTTP.start(product_uri.hostname, product_uri.port) do |http|
              http.request(query)
            end

            return Product.new(JSON.parse(res.body))
        end

        def products
            product_uri = URI("#{@uri}/api/rest/v1/products")
            query = Net::HTTP::Get.new(product_uri)
            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @access_token

            res = Net::HTTP.start(product_uri.hostname, product_uri.port) do |http|
              http.request(query)
            end

            return Product.new(JSON.parse(res.body))
        end
    end
end
