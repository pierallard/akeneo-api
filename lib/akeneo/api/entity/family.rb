require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
	class Family < Abstract
		def self::properties
			return [
				:code, :attribute_as_label, :attribute_as_image, :attributes, :attribute_requirements, 
				:labels
			]
		end

		def self::endpoint
			return :families
		end

		def self::unique_identifier
			return :code
		end

		def self::new_from_api(client, params = {})
			if (!params['attribute_as_label'].nil?) then
				params['attribute_as_label'] = Akeneo::Api::Entity::Attribute.new({
					code: params['attribute_as_label'],
					_client: client,
					_persisted: true,
					_loaded: false,
					})
			end

			if (!params['attribute_as_image'].nil?) then
				params['attribute_as_image'] = Akeneo::Api::Entity::Attribute.new({
					code: params['attribute_as_image'],
					_client: client,
					_persisted: true,
					_loaded: false,
					})
			end

			params['attributes'] = (params['attributes'] || []).map do |attribute_code|
				Akeneo::Api::Entity::Attribute.new({
					code: attribute_code,
					_client: client,
					_persisted: true,
					_loaded: false,
					})
			end

			return super(client, params)
		end

		def to_api
			return {
				code: code,
				attribute_as_label: attribute_as_label,
				attribute_as_image: attribute_as_image,
				attributes: attributes,
				attribute_requirements: attribute_requirements,
				labels: labels
			}
		end
	end
end
