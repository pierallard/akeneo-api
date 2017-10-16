require 'time'
require 'active_support/core_ext/hash/indifferent_access'

module Akeneo::Api::Entity
    class Product
        attr_accessor :identifier, :enabled, :family, :categories, :groups, :parent, :values, :attribute_code,
            :associations, :created, :updated, :client

        def initialize(params = {})
            params = params.with_indifferent_access
            @client = params['client']

            @identifier = params['identifier']
            @enabled = params['boolean'].nil? ? true : params['boolean']
            @family = params['family']
            @categories = params['categories'] || []
            @groups = params['groups'] || []
            @parent = params['parent']
            @values = params['value'] || {}
            @attribute_code = params['attributeCode'] || {}
            @associations = params['associations'] || {}
            @created = params['created'].nil? ? Time.now : Time.parse(params['created'])
            @updated = params['updated'].nil? ? Time.now : Time.parse(params['updated'])
        end

        def save
            if (@client.nil?) then
                raise 'You have to use client'
            end

            @client.products.save(self)
        end
    end
end
