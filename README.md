Plivo Ruby Library
---------------------------

Description
~~~~~~~~~~~

The Plivo Ruby library simplifies the process of making REST calls and generating RESTXML.

See `Plivo Documentation <http://www.plivo.com/docs/>`_ for more information.


GEM Installation
~~~~~~~~~~~~~

    $ sudo gem install plivo


Manual Installation
~~~~~~~~~~~~~~~~~~~~

To use the rake command to build the gem and

**Download the source and run:**
    $ sudo gem install /path/to/plivo/gem

to finish the installation

Requirements
~~~~~~~~~~~~
gem "rest-client", "~> 1.6.7"
gem "json", "~> 1.6.6"

## Configuration

Configure the Plivo REST API client in an initializer:

```ruby
# config/initializers/plivo.rb

Plivo::RestAPI.configure(ENV['PLIVO_AUTH_ID'], ENV['PLIVO_AUTH_TOKEN'])
```

Usage
~~~~~

To use the Plivo Ruby library, you will need to specify the AUTH_ID and AUTH_TOKEN, before you can make REST requests.

See `Plivo Documentation <http://www.plivo.com/docs/>`_ for more information.


## Contributing

In order to run the tests, you need a local `.env` file in the project root that defines two
environment variables: `PLIVO_AUTH_ID` and `PLIVO_AUTH_TOKEN`. These will be
loaded by the [dotenv](https://github.com/bkeepers/dotenv) gem when the test
suite loads up. These environment variables are used to configure the API client
in the test environment in order to interact with the Plivo Rest API.

Here's what a file `.env` file looks like:

```
$ cat .env
PLIVO_AUTH_ID=YOUR_AUTH_ID
PLIVO_AUTH_TOKEN=YOUR_AUTH_TOKEN
```

You can find these values in your Plivo dashboard.

API responses are recorded by the [vcr](https://github.com/vcr/vcr) gem in the `spec/fixtures/vcr_cassettes` directory.
These fixtures are not committed to source control.

Files
~~~~~

**lib/plivo.rb:** include this library in your code

License
-------

The Plivo Ruby library is distributed under the MPL 1.1 License
