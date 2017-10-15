require "akeneo/api/entity/product"
require "akeneo/api/entity/product_set"

module Akeneo::Api::ClientEndpoint
    module Product
        extend ActiveSupport::Concern

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
            return Akeneo::Api::Entity::Product.new(JSON.parse(res.body))
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
            return Akeneo::Api::Entity::ProductSet.new(self, JSON.parse(res.body))
        end
    end
end
