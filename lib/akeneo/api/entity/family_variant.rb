require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class FamilyVariant < Abstract
    attr_accessor :_family_code

    def self::properties
      return [
        :code, :labels, :variant_attribute_sets
      ]
    end

    def endpoint
      return @_client.family_variants(@_family_code)
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

      params['variant_attribute_sets'] = (params['variant_attribute_sets'] || []).map do |variant_attribute_set|
        {
          level: variant_attribute_set['level'],
          attributes: (variant_attribute_set['attributes'] || []).map do |attribute_code|
            Akeneo::Api::Entity::Attribute.new({
              code: attribute_code,
              _client: client,
              _persisted: true,
              _loaded: false
              })
          end
        }
      end

      return super(client, params)
    end

    def initialize(params = {})
      super

      @labels = {} if @labels.nil?
      @variant_attribute_sets = {} if @variant_attribute_sets.nil?
    end

    def to_api
      return {
        code: code,
        labels: labels.inject({}) {|h, (label, value)| h[label.code] = value; h},
        variant_attribute_sets: variant_attribute_sets.map do |vas|
          {
            level: vas['level'],
            attributes: vas['attributes'].map(&:code)
          }
        end
      }
    end

    def load
      entity = load_family_variant

      self.class.properties.each do |arg|
        self.send(:"#{arg}=", entity.send(arg))
      end

      @_loaded = true
    end

    def load_family_variant
      @_client.families.each do |family|
        family_variant = family.family_variants.detect do |family_variant|
          return family_variant if family_variant.code == code
        end
      end

      return nil?
    end
  end
end
