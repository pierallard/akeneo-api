require 'time'
require 'active_support/core_ext/hash/indifferent_access'
require 'akeneo/api/no_client_exception'

module Akeneo::Api::Entity
    class Product
        attr_accessor :identifier, :enabled, :family, :categories, :groups, :parent, :values, :attribute_code,
            :associations, :created, :updated, :_client, :_persisted

        def initialize(params = {})
            params = params.with_indifferent_access
            @_client = params['_client']
            @_persisted = params['_persisted'].nil? ? false : params['_persisted']

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
            raise Akeneo::Api::NoClientException if (@_client.nil?)

            @_client.products.save(self)
        end
    end
end
