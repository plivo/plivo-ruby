# plivo-ruby

[![Build Status](https://travis-ci.org/plivo/plivo-ruby.svg?branch=4.0)](https://travis-ci.org/plivo/plivo-ruby)

The Plivo Ruby SDK makes it simpler to integrate communications into your Ruby applications using the Plivo REST API. Using the SDK, you will be able to make voice calls, send SMS and generate Plivo XML to control your call flows.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'plivo', '>= 4.1.6'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install plivo

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
client = RestClient.new('your_auth_id', 'your_auth_token');
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
require 'rubygems'
require 'plivo'

include Plivo

client = RestClient.new
message_created = client.messages.create(
  'your_source_number',
  %w[your_destination_number_1 your_destination_number_2],
  'Hello, world!'
)
```

### Make a call

```ruby
require 'rubygems'
require 'plivo'

include Plivo

client = RestClient.new
call_made = client.calls.create(
  'your_source_number',
  ['your_destination_number'],
  'https://answer.url'
)
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

### More examples
Refer to the [Ruby API Reference](https://api-reference.plivo.com/latest/ruby/introduction/overview) for more examples. Also refer to the [guide to setting up dev environment](https://developers.plivo.com/getting-started/setting-up-dev-environment/) on [Plivo Developers Portal](https://developers.plivo.com) to setup a Sinatra server & use it to test out your integration in under 5 minutes.

## Reporting issues
Report any feedback or problems with this version by [opening an issue on Github](https://github.com/plivo/plivo-ruby/issues).
