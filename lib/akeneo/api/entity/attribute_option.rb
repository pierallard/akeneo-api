require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class AttributeOption < Abstract
    attr_accessor :_attribute_code

    def self::properties
      return [
        :code, :attribute, :sort_order, :labels
      ]
    end

    def endpoint
      return @_client.attribute_options(@_attribute_code)
    end

    def self::unique_identifier
      return :code
    end

    def self::new_from_api(client, params = {})
      params['labels'] = (params['labels'] || {}).inject({}) do |h, (locale_code, value)|
        h[Akeneo::Api::Entity::Locale.new({
          code: locale_code,
          _client: client,
          _persisted: true,
          _loaded: false
          })] = value
        h
      end

      if (nil != params['attribute']) then
        params['attribute'] = Akeneo::Api::Entity::Attribute.new({
          code: params['attribute'],
          _client: client,
          _persisted: true,
          _loaded: false
          })
      end

      return super(client, params)
    end

    def initialize(params = {})
      super

      @labels = {} if @labels.nil?
    end

    def to_api
      return {
        code: code,
        labels: labels.inject({}) {|h, (label, value)| h[label.code] = value; h},
        attribute: attribute.try(&:code),
        sort_order: sort_order
      }
    end

    def load
      entity = load_attribute_option

      self.class.properties.each do |arg|
        self.send(:"#{arg}=", entity.send(arg))
      end

      @_loaded = true
    end

    def load_attribute_option
      @_client.attributes.each do |attribute|
        attribute_option = attribute.attribute_options.detect do |attribute_option|
          return attribute_option if attribute_option.code == code
        end
      end

      return nil?
    end
  end
end
