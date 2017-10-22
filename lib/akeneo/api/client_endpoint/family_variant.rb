require "akeneo/api/entity/family_variant"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class FamilyVariant < Abstract
    attr_accessor :_family_code

    def self::entityClass
      return Akeneo::Api::Entity::FamilyVariant
    end

    def url
      return "families/#{@_family_code}/variants"
    end

    def initialize(_client, _family_code)
      super(_client)

      @_family_code = _family_code
    end

    def new(params = {})
      result = super(params)
      result._family_code = _family_code
      return result
    end
  end
end
