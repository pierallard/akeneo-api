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

            self.class.properties.each do |arg|
                self.class.class_eval("def #{arg}=(val);@#{arg} = val;@updated = Time.now;end")
            end
        end

        def to_api
            return {
                identifier: identifier,
                enabled: enabled,
                family: family.try(:code),
                categories: categories,
                groups: groups,
                parent: parent,
                values: values,
                associations: associations
            }
        end
    end
end
