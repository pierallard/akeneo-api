require "akeneo/api/product"
require "akeneo/api/product_set"

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

            if (!res.kind_of? Net::HTTPSuccess) then
                raise res.body
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

            if (!res.kind_of? Net::HTTPSuccess) then
                raise res.body
            end
            return Product.new(JSON.parse(res.body))
        end

        def products(options = {})
            product_uri = ''
            if (!options[:uri].nil?) then
                product_uri = URI(options[:uri])
            else
                product_uri = URI("#{@uri}/api/rest/v1/products")
                params = {}
                if (!options[:scope].nil?) then
                    params[:scope] = options[:scope]
                end
                if (!options[:locales].nil?) then
                    params[:locales] = options[:locales]
                end
                if (!options[:attributes].nil?) then
                    params[:attributes] = options[:attributes]
                end
                if (!options[:page].nil?) then
                    params[:page] = options[:page]
                end
                if (!options[:limit].nil?) then
                    params[:limit] = options[:limit]
                end
                if (!options[:with_count].nil?) then
                    params[:with_count] = options[:with_count]
                end
                if (!options[:search].nil?) then
                    params[:search] = options[:search].to_json
                end
                product_uri.query = URI.encode_www_form(params)
            end
            query = Net::HTTP::Get.new(product_uri)
            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @access_token

            res = Net::HTTP.start(product_uri.hostname, product_uri.port) do |http|
              http.request(query)
            end

            if (!res.kind_of? Net::HTTPSuccess) then
                raise res.body
            end
            return ProductSet.new(self, JSON.parse(res.body))
        end
    end
end
