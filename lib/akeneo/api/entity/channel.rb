require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class Channel < Abstract
    def self::properties
      return [
        :code, :locales, :currencies, :category_tree, :conversion_units, :labels
      ]
    end

    def endpoint
      return @_client.channels
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

      params['currencies'] = (params['currencies'] || []).map do |currency_code|
        Akeneo::Api::Entity::Currency.new({
          code: currency_code,
          _client: client,
          _persisted: true,
          _loaded: false,
          })
      end

      params['labels'] = (params['labels'] || {}).inject({}) do |h, (locale_code, value)|
        h[Akeneo::Api::Entity::Locale.new({
          code: locale_code,
          _client: client,
          _persisted: true,
          _loaded: false
          })] = value
        h
      end

      return super(client, params)
    end

    def initialize(params = {})
      super

      @labels = {} if @labels.nil?
      @locales = [] if @locales.nil?
      @currencies = [] if @currencies.nil?
      @conversion_units = {} if @conversion_units.nil?
    end

    def to_api
      return {
        code: code,
        locales: locales.map(&:code),
        currencies: currencies.map(&:code),
        category_tree: category_tree,
        conversion_units: conversion_units,
        labels: labels.inject({}) {|h, (label, value)| h[label.code] = value; h}
      }
    end
  end
end
