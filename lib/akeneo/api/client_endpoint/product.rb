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

    def delete(unique_identifier)
      call(
        "#{@_client.uri}/api/rest/v1/#{self.class.url}/#{unique_identifier}",
        Net::HTTP::Delete
        )
    end
  end
end
