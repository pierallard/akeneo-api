module Akeneo::Api
  class NoClientException < StandardError
    def initialize(message = 'You have to use the client proxy to use this method')
      super
    end
  end
end
