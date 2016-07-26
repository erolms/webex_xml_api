# WebexXmlApi

[![Build Status](https://travis-ci.org/erolms/webex_xml_api.svg?branch=master)](https://travis-ci.org/erolms/webex_xml_api)

The WebexXmlApi gem provides an interface to the Cisco WebEx Service for creating, scheduling and administering the Meetings. This gem is featuring a subset of an entire WebEx interface using the XML format.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webex_xml_api'
```

WebexXmlApi is cryptographically signed. To be sure the gem you install hasn’t been tampered with:

Add my public key (if you haven’t already) as a trusted certificate:

```ruby
gem cert --add <(curl -Ls https://raw.github.com/erolms/webex_xml_api/master/certs/erolms.pem)
```

The MediumSecurity trust profile will verify signed gems, but allow the installation of unsigned dependencies.

This is necessary because not all of WebexXmlApi’s dependencies are signed, so we cannot use HighSecurity.

Execute:

```ruby
    $ bundle
```

Or install it yourself as:

```ruby
    $ gem install webex_xml_api -P MediumSecurity
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/erolms/webex_xml_api.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Copyrights

[WebEx](https://www.webex.com/) is a Trademark of the [Cisco](https://www.cisco.com/) Corporation.

