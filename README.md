# plivo-ruby

[![UnitTest](https://github.com/plivo/plivo-ruby/actions/workflows/unitTests.yml/badge.svg?branch=ns-ut-fix)](https://github.com/plivo/plivo-ruby/actions/workflows/unitTests.yml)
[![Gem Version](https://badge.fury.io/rb/plivo.svg)](https://badge.fury.io/rb/plivo)

The Plivo Ruby SDK makes it simpler to integrate communications into your Ruby applications using the Plivo REST API. Using the SDK, you will be able to make voice calls, send SMS and generate Plivo XML to control your call flows.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'plivo', '>= 4.48.0'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plivo

For features in beta, use the beta branch:

    $ gem install plivo --pre

If you have the `0.3.19` version (a.k.a legacy) already installed, you may have to first uninstall it before installing the new version.

## Getting started

### Authentication
To make the API requests, you need to create a `RestClient` and provide it with authentication credentials (which can be found at [https://console.plivo.com/dashboard/](https://console.plivo.com/dashboard/)).

We recommend that you store your credentials in the `PLIVO_AUTH_ID` and the `PLIVO_AUTH_TOKEN` environment variables, so as to avoid the possibility of accidentally committing them to source control. If you do this, you can initialise the client with no arguments and it will automatically fetch them from the environment variables:

```ruby
client = RestClient.new;
```

Alternatively, you can specifiy the authentication credentials while initializing the `RestClient`.

```ruby
client = RestClient.new('<auth_id>', '<auth_token>');
```

### The basics
The SDK uses consistent interfaces to create, retrieve, update, delete and list resources. The pattern followed is as follows:

```ruby
client.resources.create(params); # Create
client.resources.get(resource_identifier); # Get
client.resources.update(resource_identifier, params); # Update
client.resources.delete(resource_identifier); # Delete
client.resources.list; # List all resources, max 20 at a time
```

You can also use the `resource` directly to update and delete it. For example,

```ruby
resource = client.resources.get(resource_identifier);
resource.update(params); # update the resource
resource.delete(); # Delete the resource
```

Also, using `client.resources.list` would list the first 20 resources by default (which is the first page, with `limit` as 20, and `offset` as 0). To get more, you will have to use `limit` and `offset` to get the second page of resources.

To list all resources, you can simply use the following pattern that will handle the pagination for you automatically, so you won't have to worry about passing the right `limit` and `offset` values.

```ruby
client.resources.each do |resource|
  puts resource.id
end
```

## Examples

### Send a message

```ruby
require "plivo"
include Plivo

client = RestClient.new
response = client.messages.create(
  src: '+14156667778',
  dst: '+14156667777',
  text: 'Hello, this is a sample text'
  )
```

### Make a call

```ruby
require 'rubygems'
require 'plivo'

include Plivo

client = RestClient.new
call_made = client.calls.create(
  '+14156667778',
  ['+14156667777'],
  'https://answer.url'
)
```

### Lookup a number

```ruby
require 'rubygems'
require 'plivo'

include Plivo

client = RestClient.new
resp = client.lookup.get('<number-here>')
```

### Generate Plivo XML

```ruby
require 'rubygems'
require 'plivo'

include Plivo::XML

response = Response.new
response.addSpeak('Hello, world!')
puts response.to_xml # Prints the XML string

xml_response = PlivoXML.new(response)
puts xml_response.to_xml # Prints XML along with XML version & encoding details
```
This generates the following XML:

```xml
<?xml version="1.0" encoding="utf-8" ?>
<Response>
  <Speak>Hello, world!</Speak>
</Response>
```

### Run a PHLO

```ruby
require 'rubygems'
require 'plivo'

include Plivo

client = Phlo.new('<auth_id>', '<auth_token>')

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = Phlo.new

# run a phlo:
begin
    #parameters set in PHLO - params
    params = {
       from: '+14156667778',
       to: '+14156667777'
    }
    response = phlo.run(params)
    puts response
  rescue PlivoRESTError => e
    puts 'Exception: ' + e.message
  end
```

### More examples
More examples are available [here](https://github.com/plivo/plivo-examples-ruby). Also refer to the [guides for configuring the Rails server to run various scenarios](https://www.plivo.com/docs/sms/quickstart/ruby-rails/) & use it to test out your integration in under 5 minutes.

## Reporting issues
Report any feedback or problems with this version by [opening an issue on Github](https://github.com/plivo/plivo-ruby/issues).

## Local Development
> Note: Requires latest versions of Docker & Docker-Compose. If you're on MacOS, ensure Docker Desktop is running.
1. Export the following environment variables in your host machine:
```bash
export PLIVO_AUTH_ID=<your_auth_id>
export PLIVO_AUTH_TOKEN=<your_auth_token>
export PLIVO_API_DEV_HOST=<plivoapi_dev_endpoint>
export PLIVO_API_PROD_HOST=<plivoapi_public_endpoint>
```
2. Run `make build`. This will create a docker container in which the sdk will be setup and dependencies will be installed.
> The entrypoint of the docker container will be the `setup_sdk.sh` script. The script will handle all the necessary changes required for local development.
3. The above command will print the docker container id (and instructions to connect to it) to stdout.
4. The testing code can be added to `<sdk_dir_path>/ruby-sdk-test/test.rb` in host  
 (or `/usr/src/app/ruby-sdk-test/test.rb` in container)
5. The sdk directory will be mounted as a volume in the container. So any changes in the sdk code will also be reflected inside the container.
> To use the local code in the test file, import the sdk in test file using:   
`require "/usr/src/app/lib/plivo.rb"`   
6. To run test code, run `make run CONTAINER=<cont_id>` in host.
7. To run unit tests, run `make test CONTAINER=<cont_id>` in host.
> `<cont_id>` is the docker container id created in 2.
(The docker container should be running)

> Test code and unit tests can also be run within the container using
`make run` and `make test` respectively. (`CONTAINER` argument should be omitted when running from the container)