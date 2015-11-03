# Lotus::Shrine

This gem aims at providing support for [Shrine](https://github.com/janko-m/shrine) uploader in Lotus applications. It also tries to be as simple as possible, without polluting the world around.

For now it's not released to RubyGems so please, use the git version. I promise to release as soon as I think it makes any sense :wink:

[![Build Status](https://travis-ci.org/katafrakt/lotus-shrine.svg)](https://travis-ci.org/katafrakt/lotus-shrine)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lotus-shrine', github: 'katafrakt/lotus-shrine'
```

And then execute:

    $ bundle

## Usage

Setup Shrine as described in [its repo](https://github.com/janko-m/shrine). Then, in your repository add (assuming your attachment is `avatar`):

```ruby
include Lotus::Shrine::Repository[:avatar]
```

Adn in your entity:

```ruby
include YourUploader[:avatar] # YourUploader should inherit from Shrine, of course
```

To use validations, include this in your entity too:

```ruby
include Lotus::Shrine::Validations
```

Remember that you have to call `valid?` or `validate` yourself. There is not as much magic in Lotus as it is in Rails :wink:

For inspiration look at [the specs](https://github.com/katafrakt/lotus-shrine/tree/master/spec/lotus) or [example repo](https://github.com/katafrakt/lotus-shrine-example).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/katafrakt/lotus-shrine.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Cat images (used in tests) are public domain taken from [Wikimedia Commons](http://commons.wikimedia.org).
