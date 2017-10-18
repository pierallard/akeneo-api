require 'json'

module Akeneo::Api
    class QueryException < StandardError
    	attr_accessor :code, :message, :errors

        def initialize(body)
            json = JSON.parse(body)

            @code = json['code']
            @errors = json['errors']
            @message = json['message']

            super("#{@message} - code: #{@code} - errors: #{@errors}")
        end

        def code
            @code.to_i
        end
    end
end
