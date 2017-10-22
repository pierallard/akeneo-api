require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class Currency < Abstract
    def self::properties
      return [
        :code, :enabled
      ]
    end

    def endpoint
      return @_client.currencies
    end

    def self::unique_identifier
      return :code
    end

    def to_api
      return {
        code: code,
        enabled: enabled
      }
    end
  end
end
