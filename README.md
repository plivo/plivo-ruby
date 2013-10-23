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



Files
~~~~~

**lib/plivo.rb:** include this library in your code

License
-------

The Plivo Ruby library is distributed under the MPL 1.1 License
