require "akeneo/api/entity/attribute"
require "akeneo/api/client_endpoint/abstract"

module Akeneo::Api::ClientEndpoint
    class Family < Abstract
        def self::entityClass
            return Akeneo::Api::Entity::Family
        end
        
        def self::url
        	return 'families'
        end

        def self::map_from_api(client, params)
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
                new Akeneo::Api::Entity::Attribute.new({
                    code: attribute_code,
                    _client: client,
                    _persisted: true,
                    _loaded: false,
                })
            end

            return params
        end
    end
end
