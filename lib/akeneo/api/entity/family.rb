require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class Family < Abstract
    def self::properties
      return [
        :code, :attribute_as_label, :attribute_as_image, :attributes, :attribute_requirements, 
        :labels
      ]
    end

    def self::endpoint
      return :families
    end

    def self::unique_identifier
      return :code
    end

    def self::new_from_api(client, params = {})
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
        Akeneo::Api::Entity::Attribute.new({
          code: attribute_code,
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
      @attributes = [] if @attributes.nil?
      @attribute_requirements = {} if @attribute_requirements.nil?
    end

    def to_api
      return {
        code: code,
        attribute_as_label: attribute_as_label.try(:code),
        attribute_as_image: attribute_as_image.try(:code),
        attributes: attributes.map(&:code),
        attribute_requirements: attribute_requirements,
        labels: labels
      }
    end
  end
end
