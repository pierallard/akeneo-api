require "akeneo/api/entity/attribute_option"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class AttributeOption < Abstract
    attr_accessor :_attribute_code

    def self::entityClass
      return Akeneo::Api::Entity::AttributeOption
    end

    def url
      return "attributes/#{@_attribute_code}/options"
    end

    def initialize(_client, _attribute_code)
      super(_client)

      @_attribute_code = _attribute_code
    end

    def new(params = {})
      result = super(params)
      result._attribute_code = _attribute_code
      return result
    end
  end
end
