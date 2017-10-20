require "akeneo/api/entity/channel"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
	class Channel < Abstract
		def self::entityClass
			return Akeneo::Api::Entity::Channel
		end
		
		def self::url
			return 'channels'
		end
	end
end
