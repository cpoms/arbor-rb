# Ruby Interface for Arbor API

A Ruby interface to [Arbor Education API](http://www.arbor-education.com/developers.html).

## Installation

    gem install arbor

## Usage

    require 'arbor'

    client = Arbor::Client.new("some-school", "user@email.net", "abc123")

    # retrieve all students
    students = client.query(:students)

    students.each do |s|
      puts "#{s.person.legal_first_name} #{s.person.legal_last_name}
    end

    # use `retrieve` to get a single resource
    student = client.retrieve(:student, 1)
    #<Arbor::Model::Person:0x8ba8940

    # by default, it serialises the API responses in to classes defined for
    # each resource. you can set your own serialiser for a resource type:
    Arbor.serialisers.register(:students, MyStudentSerialiser)

    # and/or modify the default serialiser. serialiser classes must respond to
    # `deserialise` and return a single resource
    Arbor.serialisers.default_serialiser = MyDefaultSerialiser

    # resources loaded by `query` (listings) are lazily loaded, and will
    # generate another request for that specific resource when an attribute is
    # requested which isn't already loaded
    student.person # extra request to /rest-v2/students/1 occurs here
    => #<Arbor::Model::Person:0x8ba8940 ... >

## Still to do

- Write tests
- Support the other stuff like ordering, paging, changelog etc.
- Include an API mixin for the resource classes

## Licence

[MIT License](http://opensource.org/licenses/MIT)
