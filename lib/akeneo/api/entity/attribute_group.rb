require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class AttributeGroup < Abstract
    def self::properties
      return [
        :code, :sort_order, :attributes, :labels
      ]
    end

    def self::endpoint
      return :"attribute_groups"
    end

    def self::unique_identifier
      return :code
    end

    def self::new_from_api(client, params = {})
      params['attributes'] = (params['attributes'] || []).map do |attribute_code|
        Akeneo::Api::Entity::Attribute.new({
          code: attribute_code,
          _client: client,
          _persisted: true,
          _loaded: false
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

      @attributes = [] if @attributes.nil?
      @labels = {} if @labels.nil?
      @sort_order = 0 if @sort_order.nil?
    end

    def to_api
      return {
        code: code,
        sort_order: sort_order,
        attributes: attributes.map(&:code),
        labels: labels.inject({}) {|h, (label, value)| h[label.code] = value; h}
      }
    end
  end
end
