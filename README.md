# Akeneo::Api

This repository allows you to use [Akeneo API](https://api.akeneo.com) with your Ruby projects

## Installation

Install it in your application with 

    $ gem install akeneo-api

## Usage

You first need to initialise the client with your credentials client id/secret and with your user/password.

If you don't have any client id, let's take a look at [this page](https://api.akeneo.com/documentation/security.html#authentication) to create it. 

    client = Akeneo::Api::Client.new('http://localhost:8000')
    client.authenticate('client_id', 'secret', 'admin', 'admin')

Next, you can access to entities using the same [API reference](https://api.akeneo.com/api-reference.html).

    product = client.product('11704300')
    print product.identifier

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/pierallard/akeneo-api](https://github.com/pierallard/akeneo-api).
