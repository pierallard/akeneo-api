require "akeneo/api/entity/attribute_group"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class AttributeGroup < Abstract
    def self::entityClass
      return Akeneo::Api::Entity::AttributeGroup
    end
    
    def self::url
      return 'attribute-groups'
    end
  end
end
