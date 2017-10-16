require "akeneo/api/entity/product"
require "akeneo/api/entity/family"
require "akeneo/api/entity/product_set"
require 'akeneo/api/query_exception'
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
    class Product < Abstract
        def self::entityClass
            Akeneo::Api::Entity::Product
        end

        def self::url
            return 'products'
        end

        def self::map_from_api(client, params)
            if (!params['family'].nil?) then
                params['family'] = Akeneo::Api::Entity::Family.new({
                    code: params['family'],
                    _client: client,
                    _persisted: true,
                    _loaded: false,
                })
            end

            return params
        end

        def where(options = {})
            product_uri = ''
            if (!options[:uri].nil?) then
                product_uri = URI(options[:uri])
            else
                product_uri = URI("#{@_client.uri}/api/rest/v1/products")
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
                    params[:search] = JSON.generate(options[:search])
                end
                product_uri.query = URI.encode_www_form(params)
            end
            query = Net::HTTP::Get.new(product_uri)
            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @_client.access_token

            res = Net::HTTP.start(product_uri.hostname, product_uri.port) do |http|
              http.request(query)
            end

            raise Akeneo::Api::QueryException.new(res.body) if (!res.kind_of? Net::HTTPSuccess)

            return Akeneo::Api::Entity::ProductSet.new(JSON.parse(res.body).merge({ _client: @_client }))
        end

        def save(product)
            if (!product._persisted) then
                product_uri = URI("#{@_client.uri}/api/rest/v1/products")
                query = Net::HTTP::Post.new(product_uri)
            else
                product_uri = URI("#{@_client.uri}/api/rest/v1/products/#{product.identifier}")
                query = Net::HTTP::Patch.new(product_uri)
            end

            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @_client.access_token
            query.body = JSON.generate({
                identifier: product.identifier,
                enabled: product.enabled,
                family: product.family.try(:code),
                categories: product.categories,
                groups: product.groups,
                parent: product.parent,
                values: product.values,
                associations: product.associations
            })

            res = Net::HTTP.start(product_uri.hostname, product_uri.port) do |http|
                http.request(query)
            end

            print res.body
            raise Akeneo::Api::QueryException.new(res.body) if (!res.kind_of? Net::HTTPSuccess)

            product._persisted = true

            return true
        end
    end
end
