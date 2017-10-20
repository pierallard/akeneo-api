require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
	class AttributeGroup < Abstract
		def self::properties
			return [
				:code, :sort_order, :attributes, :labels
			]
		end

		def self::endpoint
			return :"attribute_groups"
		end

		def self::unique_identifier
			return :code
		end

		def to_api
			return {
				code: code,
				sort_order: sort_order,
				attributes: attributes,
				labels: labels
			}
		end
	end
end
