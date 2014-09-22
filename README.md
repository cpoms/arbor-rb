# Ruby Interface for Arbor API

An unofficial Ruby interface to [Arbor Education API](http://www.arbor-education.com/developers.html).

## Installation

    gem install arbor

## Usage

```ruby
require 'arbor'

client = Arbor::Client.new("some-school", "user@email.net", "abc123")

# retrieve all students
students = client.query(:students)

# resources loaded by `query` (listings) are lazily loaded, and will
# generate another request for that specific resource when an attribute is
# requested which isn't already loaded
students.each do |s|
  # extra requests to /rest-v2/students/<id> (s.href) occur here for each item
  puts "#{s.person.legal_first_name} #{s.person.legal_last_name}"
end

# use `retrieve` to get a single resource
student = client.retrieve(:student, 1)

# by default, it serialises the API responses in to classes defined for
# each resource. you can set your own serialiser for a resource type:
Arbor.serialisers.register(:students, MyStudentSerialiser)

# and/or modify the default serialiser. serialiser classes must respond to
# `deserialise` and return a single resource
Arbor.serialisers.default_serialiser = MyDefaultSerialiser
```

## Still to do

- Write tests
- Support the other stuff like ordering, paging, changelog etc.
- Include an API mixin for the resource classes
- RDoc it up

## Licence

[MIT License](http://opensource.org/licenses/MIT)
