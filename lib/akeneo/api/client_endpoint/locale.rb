require "akeneo/api/entity/locale"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
  class Locale < Abstract
    def self::entityClass
      return Akeneo::Api::Entity::Locale
    end
    
    def self::url
      return 'locales'
    end
  end
end
