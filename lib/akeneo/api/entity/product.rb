require 'time'
require 'active_support/core_ext/hash/indifferent_access'
require 'akeneo/api/no_client_exception'
require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
    class Product < Abstract
        def self::properties
            return [
                :identifier, :enabled, :family, :categories, :groups, :parent, :values, :attribute_code,
                :associations, :created, :updated
            ]
        end

        def self::endpoint
            return :products
        end

        def self::unique_identifier
            return :identifier
        end

        def initialize(params = {})
            super
            params = params.with_indifferent_access

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
    end
end
