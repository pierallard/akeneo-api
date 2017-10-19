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
