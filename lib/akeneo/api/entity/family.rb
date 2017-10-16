module Akeneo::Api::Entity
	class Family
        attr_accessor :code, :attribute_as_label, :attribute_as_image, :attributes, 
        	:attribute_requirements, :labels, :_client, :_persisted, :_loaded

        def initialize(params = {})
        	params = params.with_indifferent_access
            @_client = params['_client']
            @_persisted = params['_persisted'].nil? ? false : params['_persisted']
            @_loaded = params['_loaded'].nil? ? false : params['_loaded']

            @code = params['code']
            @attribute_as_label = params['attribute_as_label']
            @attribute_as_image = params['attribute_as_image']
            @attributes = params['attributes'] || []
            @attribute_requirements = params['attribute_requirements'] || {}
            @labels = params['labels'] || {}
        end

        def load
        	family = @_client.families.find(@code)

        	@attribute_as_label = family.attribute_as_label
        	@attribute_as_image = family.attribute_as_image
        	@attributes = family.attributes
        	@attribute_requirements = family.attribute_requirements
        	@labels = family.labels

        	@_loaded = true
        end

        def attribute_as_label
        	load if !@_loaded
        	return @attribute_as_label
        end
    end
end
