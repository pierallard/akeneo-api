module Akeneo::Api::Entity
	class Abstract
		attr_accessor :_client, :_persisted, :_loaded

        def self::properties
        	# Implement the entity properties like [:code, :attribute...]
            raise NotImplementedError
        end

        def self::endpoint
        	# The name of the endpoint in the client (:families)
            raise NotImplementedError
        end

        def self::unique_identifier
        	# The unique identifier for the API (:code)
            raise NotImplementedError
        end

        def initialize(params = {})
        	params = params.with_indifferent_access
            @_client = params[:_client]
            @_persisted = params[:_persisted].nil? ? false : params[:_persisted]
            @_loaded = params[:_loaded].nil? ? false : params[:_loaded]

            self.class.properties.each do |arg|
			    self.class.class_eval("def #{arg};load if !@_loaded && @_persisted;@#{arg};end")
			    self.class.class_eval("def #{arg}=(val);@#{arg}=val;end")
		    end
        end

        def load
            raise Akeneo::Api::NoClientException if (@_client.nil?)

        	entity = @_client
        		.send(self.class.endpoint)
        		.find(self.send(:"#{self.class.unique_identifier}"))

        	self.class.properties.each do |arg|
        		self.send(:"#{arg}=", entity.send(arg))
        	end

        	@_loaded = true
        end

        def save
            raise Akeneo::Api::NoClientException if (@_client.nil?)

            @_client.send(self.class.endpoint).save(self)
        end
	end
end