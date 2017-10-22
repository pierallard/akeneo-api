require "akeneo/api/entity/attribute"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class Attribute < Abstract
    def self::entityClass
      return Akeneo::Api::Entity::Attribute
    end
    
    def self::url
      return 'attributes'
    end
  end
end
