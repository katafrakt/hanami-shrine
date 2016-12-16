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
prepend ImageAttachment.repository(:avatar)
```

And in your entity:

```ruby
include ImageAttachment[:avatar]
```

For inspiration read a [blog post](http://katafrakt.me/2016/02/04/shrine-hanami-uploads/), look at [the specs](https://github.com/katafrakt/hanami-shrine/tree/master/spec/hanami) or [example repo](https://github.com/katafrakt/hanami-shrine-example).

## Important changes since 0.1 version

As Hanami has been upgraded to 0.9, it started to use new engine for the entities in `hanami-model`. It required heavy changes in `hanami-shrine` to accomodate to new paradigm. Unfortunately, some of them are breaking. Here's a summary list:
* Validations are gone (for now, hopefully)
* You need to use `prepend` instead of `extend` in your repository
* Entities are now read-only. You need to initialize them with the attachment, not add it later: `MyEntity.new(avatar: File.open('my_avatar.png')`. This is a Hanami change, but it's worth mentioning here as well.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katafrakt/hanami-shrine.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Cat images (used in tests) are public domain taken from [Wikimedia Commons](http://commons.wikimedia.org).
