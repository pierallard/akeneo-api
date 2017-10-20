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

			@enabled = true if @enabled.nil?
			@categories = [] if @categories.nil?
			@groups = [] if @groups.nil?
			@associations = {} if @associations.nil?

			self.class.properties.each do |arg|
				self.class.class_eval("def #{arg}=(val);@#{arg} = val;@updated = Time.now;end")
			end
		end

		def delete
			raise Akeneo::Api::NoClientException if (@_client.nil?)

			return @_client.products.delete(unique_identifier)
		end

		def self::new_from_api(client, params = {})
			if (!params['family'].nil?) then
				params['family'] = Akeneo::Api::Entity::Family.new({
					code: params['family'],
					_client: client,
					_persisted: true,
					_loaded: false,
					})
			end

			params['created'] = params['created'].nil? ? Time.now : Time.parse(params['created'])
			params['updated'] = params['updated'].nil? ? Time.now : Time.parse(params['updated'])

			return super(client, params)
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
