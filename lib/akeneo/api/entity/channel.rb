require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
	class Channel < Abstract
        def self::properties
            return [
                :code, :locales, :currencies, :category_tree, :conversion_units, :labels
            ]
        end

        def self::endpoint
            return :"channels"
        end

        def self::unique_identifier
            return :code
        end

        def self::new_from_api(client, params = {})
            params['locales'] = (params['locales'] || []).map do |locale_code|
                Akeneo::Api::Entity::Locale.new({
                    code: locale_code,
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
                locales: locales.map(&:code),
                currencies: currencies,
                category_tree: category_tree,
                conversion_units: conversion_units,
                labels: labels
            }
        end
    end
end
