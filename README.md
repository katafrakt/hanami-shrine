# Hanami::Shrine

This gem aims at providing support for [Shrine](https://github.com/shrinerb/shrine) uploader in Hanami applications. It also tries to be as simple as possible, without polluting the world around.

[![Build Status](https://travis-ci.org/katafrakt/hanami-shrine.svg)](https://travis-ci.org/katafrakt/hanami-shrine)
[![Gem Version](https://badge.fury.io/rb/hanami-shrine.svg)](https://badge.fury.io/rb/hanami-shrine)
[![Code Climate](https://codeclimate.com/github/katafrakt/hanami-shrine/badges/gpa.svg)](https://codeclimate.com/github/katafrakt/hanami-shrine)

### Current compatibility status

#### **0.1.x**
* works with Hanami 0.7.x
* works with Hanami 0.8.x without validations (which have been extracted to separate gem)

#### **0.2.x**
* works with Hanami 0.9.x and 1.0. 

Future compatibility will only be provided with Hanami 1.0 and later (which will propably be compatible with 0.9 too).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-shrine'
```

And then execute:

    $ bundle

## Usage

Setup Shrine with `hanami` plugin enabled. Check [Shrine's repository](https://github.com/shrinerb/shrine) for more detailed description of the process.

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

### Testing

Testing is done against 3 major database engines: PostgreSQL, MySQL and sqlite3. It is steered by environment variable `DB`. To run locally, forst `cp .env.travis .env`, then put values matching your local configuration there. After that, you can test all three versions:

```
DB=sqlite bundle exec rake
DB=postgres bundle exec rake
DB=mysql bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katafrakt/hanami-shrine.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Cat images (used in tests) are public domain taken from [Wikimedia Commons](http://commons.wikimedia.org).
