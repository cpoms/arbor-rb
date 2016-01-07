# Ruby Interface for Arbor API

A Ruby interface to [Arbor Education API](http://www.arbor-education.com/en/developers).

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

# the default serializer is a class factory that creates a class for each
# resource type, and returns instances of those dynamic classes. you can
# also register your own serialisers:
Arbor.serialisers.register(:students, MyStudentSerialiser)

# and/or modify the default serialiser. serialiser classes must respond to
# `load` and return a single resource
Arbor.serialisers.default_serialiser = MyDefaultSerialiser
```

## Still to do

- Write tests
- Support the other stuff like ordering, paging, changelog etc.
- Include an API mixin for the resource classes
- Support more than just read (create, edit, destroy?)

## Licence

[MIT License](http://opensource.org/licenses/MIT)
