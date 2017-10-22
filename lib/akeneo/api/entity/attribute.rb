require "akeneo/api/entity/abstract"

module Akeneo::Api::Entity
  class Attribute < Abstract
    def self::properties
      return [
        :code, :type, :labels, :group, :sort_order, :localizable, :scopable, :available_locales, :unique,
        :useable_as_grid_filter, :max_characters, :validation_rule, :validation_regexp, :wysiwyg_enabled,
        :number_min, :number_max, :decimals_allowed, :negative_allowed, :metric_family, :default_metric_unit,
        :date_min, :date_max, :allowed_extensions, :max_file_size
      ]
    end

    def endpoint
      return @_client.attributes
    end

    def self::unique_identifier
      return :code
    end

    def self::new_from_api(client, params = {})
      if (!params['group'].nil?) then
        params['group'] = Akeneo::Api::Entity::AttributeGroup.new({
          code: params['group'],
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
      params = params.with_indifferent_access

      @labels = {} if @labels.nil?
      @available_locales = [] if @available_locales.nil?
      @allowed_extensions = [] if @allowed_extensions.nil?
      @localizable = false if @localizable.nil?
      @scopable = false if @scopable.nil?
      @useable_as_grid_filter = false if @useable_as_grid_filter.nil?
      @sort_order = 0 if @sort_order.nil?
      @unique = false if @unique.nil?
      @decimals_allowed = false if @decimals_allowed.nil?
      @negative_allowed = false if @negative_allowed.nil?
    end

    def to_api
      return {
        code: code,
        type: type,
        labels: labels.inject({}) {|h, (label, value)| h[label.code] = value; h},
        group: group.try(:code),
        sort_order: sort_order,
        localizable: localizable,
        scopable: scopable,
        available_locales: available_locales,
        unique: unique,
        useable_as_grid_filter: useable_as_grid_filter,
        max_characters: max_characters,
        validation_rule: validation_rule,
        validation_regexp: validation_regexp,
        wysiwyg_enabled: wysiwyg_enabled,
        number_min: number_min,
        number_max: number_max,
        decimals_allowed: decimals_allowed,
        negative_allowed: negative_allowed,
        metric_family: metric_family,
        date_min: date_min,
        date_max: date_max,
        allowed_extensions: allowed_extensions,
        max_file_size: max_file_size
      }
    end

    def attribute_options
      return @_client.send(:attribute_options, code)
    end
  end
end
