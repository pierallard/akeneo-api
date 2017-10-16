require "akeneo/api/entity/family"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
    class Family < Abstract
        def self::entityClass
            return Akeneo::Api::Entity::Family
        end
        
        def self::url
        	return 'families'
        end
    end
end
