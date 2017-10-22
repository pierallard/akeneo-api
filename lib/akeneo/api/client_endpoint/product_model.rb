require "akeneo/api/client_endpoint/abstract"
require "akeneo/api/entity/product_model"

module Akeneo::Api::ClientEndpoint
  class ProductModel < Abstract
    def self::entityClass
      Akeneo::Api::Entity::ProductModel
    end

    def self::url
      return 'product-models'
    end
  end
end
