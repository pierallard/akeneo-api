require "akeneo/api/entity/currency"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class Currency < Abstract
    def self::entityClass
      return Akeneo::Api::Entity::Currency
    end
    
    def self::url
      return 'currencies'
    end

    def find(unique_identifier)
      raise NoMethodError.new("find method unavailable for this endpoint")
    end

    def save(entity)
      raise NoMethodError.new("save method unavailable for this endpoint")
    end

    def delete(entity)
      raise NoMethodError.new("delete method unavailable for this endpoint")
    end
  end
end
