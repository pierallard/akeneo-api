require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
	class Locale < Abstract
		def self::properties
			return [
				:code, :enabled
			]
		end

		def self::endpoint
			return :"locales"
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
