# Hanami::Shrine

This gem aims at providing support for [Shrine](https://github.com/janko-m/shrine) uploader in Hanami applications. It also tries to be as simple as possible, without polluting the world around.

[![Build Status](https://travis-ci.org/katafrakt/hanami-shrine.svg)](https://travis-ci.org/katafrakt/hanami-shrine)
[![Gem Version](https://badge.fury.io/rb/hanami-shrine.svg)](https://badge.fury.io/rb/hanami-shrine)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-shrine'
```

And then execute:

    $ bundle

## Usage

Setup Shrine with `hanami` plugin enabled. Check [Shrine's repository](https://github.com/janko-m/shrine) for more detailed description of the process.

```ruby
class ImageAttachment < Shrine
  plugin :hanami
end
```

Then, in your repository add (assuming your attachment is `avatar`):

```ruby
extend ImageAttachment.repository(:avatar)
```

And in your entity:

```ruby
include ImageAttachment[:avatar]
```

To use validations, enable them during setup of the plugin:

```ruby
class ImageAttachment < Shrine
  plugin :hanami, validations: true
end
```

And you can write some validation code. For example:

```ruby
class ImageAttachment < Shrine
  plugin :validation_helpers
  plugin :determine_mime_type
  plugin :hanami, validations: true

  Attacher.validate do
    validate_max_size 180_000, message: "is too large (max is 2 MB)"
    validate_mime_type_inclusion ["image/jpg", "image/jpeg"]
  end
end
```

Remember that you have to call `valid?` or `validate` yourself. There is not as much magic in Hanami as it is in Rails :wink:

For inspiration look at [the specs](https://github.com/katafrakt/hanami-shrine/tree/master/spec/hanami) or [example repo](https://github.com/katafrakt/hanami-shrine-example).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katafrakt/hanami-shrine.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Cat images (used in tests) are public domain taken from [Wikimedia Commons](http://commons.wikimedia.org).
