require "akeneo/api/entity/product"
require "akeneo/api/entity/family"
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

            params['created'] = params['created'].nil? ? Time.now : Time.parse(params['created'])
            params['updated'] = params['updated'].nil? ? Time.now : Time.parse(params['updated'])

            return params
        end

        def scope(scope)
            @_params[:scope] = scope

            return self
        end

        def locales(locales = [])
            @_params[:locales] = locales

            return self
        end

        def attributes(attributes = [])
            @_params[:attributes] = attributes

            return self
        end

        def search(search = {})
            @_params[:search] = JSON.generate(search)

            return self
        end
    end
end
