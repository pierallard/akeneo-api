module Akeneo::Api::ClientEndpoint
    class Abstract
        def initialize(_client)
            @_client = _client
        end

        def self::entityClass
            raise NotImplementedError
        end

        def self::url
        	raise NotImplementedError
        end

        def self::map_from_api(client, params)
        	return params
        end

        def new(params = {})
            return self.class.entityClass.new(params.merge({ _client: @_client }))
        end

        def find(code)
            find_uri = URI("#{@_client.uri}/api/rest/v1/#{self.class.url}/#{code}")
            query = Net::HTTP::Get.new(find_uri)
            query.content_type = 'application/json'
            query['authorization'] = 'Bearer ' + @_client.access_token

            res = Net::HTTP.start(find_uri.hostname, find_uri.port) do |http|
              	http.request(query)
            end

            if (!res.kind_of? Net::HTTPSuccess) then
                if (res.code.to_i == 404) then
                    return nil
                else
                    raise Akeneo::Api::QueryException.new(res.body)
                end
            end

            result = JSON.parse(res.body)

            return new(self.class.map_from_api(@_client, result).merge({
            	_persisted: true,
            	_loaded: true
        	}))
        end
    end
end	