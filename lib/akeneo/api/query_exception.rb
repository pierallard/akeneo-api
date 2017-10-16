require 'json'

module Akeneo::Api
    class QueryException < StandardError
        def initialize(body)
            json = JSON.parse(body)
            super("#{json['message']} - code: #{json['code']}")
        end
    end
end
