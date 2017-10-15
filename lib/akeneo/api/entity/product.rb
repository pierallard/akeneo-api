module Akeneo::Api::Entity
    class Product
        attr_accessor :identifier, :enabled, :family, :categories, :groups, :parent, :values, :attribute_code,
            :associations, :created, :updated

        def initialize(params)
            @identifier = params['identifier']
            @enabled = params['boolean']
            @family = params['family']
            @categories = params['categories']
            @groups = params['groups']
            @parent = params['parent']
            @values = params['value']
            @attribute_code = params['attributeCode']
            @associations = params['associations']
            @created = Time.parse(params['created'])
            @updated = Time.parse(params['updated'])
        end
    end
end
