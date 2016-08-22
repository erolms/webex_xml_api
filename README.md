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

WebEx XML API requires you to provide the WebEx Login credentials in some way. Following are required parameters for successful authentication agains WebEx:

1. **site_name** (Your Site Name - easily identified in the webex.com URL)
2. **webex_id** 
3. **password** or **session_ticket**

To create a WebEx Meeting you need to use **WebexXmlApi::Meeting::CreateMeeting** Service call. Here's an example (output from the console):

```ruby
  sm = WebexXmlApi::Meeting::CreateMeeting.new(site_name: 'test', webex_id: 'username', password: 'password')
  sm.conf_name = 'Name of the Telephone Conference' # REQUIRED: set the name of your conference
  sm.agenda = 'Meeting Agenda'            # OPTIONAL: set the agenda
  sm.start_date = '07/29/2016 15:00:00'   # REQUIRED: start time; note the MM/DD/YYYY HH:MM:SS format, or provide a DateTime object
  sm.duration = '30'                      # REQUIRED: duration in Minutes
  sm.open_time = '900'                    # OPTIONAL: time before the start in seconds where participants can join the meeting
  sm.send_request
  => {"meetingkey"=>"123456789", "iCalendarURL"=>{"host"=>"https://test.webex.com/test/j.php?MTID=aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", "attendee"=>"https://test.webex.com/test/j.php?MTID=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"}, "guestToken"=>"cccccccccccccccccccccccccccccccc", "type"=>"meet:createMeetingResponse"}
```

This will create a very basic meeting for you.

Using the **meetingkey** you can retrieve further details of your Meeting (**WebexXmlApi::Meeting::GetMeeting**), get URL for joining the meeting (**WebexXmlApi::Meeting::GetjoinurlMeeting**) or delete it (**WebexXmlApi::Meeting::DelMeeting**).

WebexXmlApi is throwing Exceptions, make sure you implement `begin..rescue` blocks. Following Exceptions are being raised:

* **NotEnoughArguments** - API Method is missing parameters required to fulfill the WebEx request
* **RequestFailed** - Raised if WebEx API Interface returns an error. The error message sent by the WebEx can be retrieved from the message property and entire response object for debugging purposes is stored in the response propery.

Further usage details can be found in [Wiki Site](https://github.com/erolms/webex_xml_api/wiki) here at GitHub or in the gem documentation.

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

The gem is available as open source under the terms of the [MIT License](https://raw.githubusercontent.com/erolms/webex_xml_api/master/LICENSE.txt).

## Copyrights

[WebEx](https://www.webex.com/) is a Trademark of the [Cisco](https://www.cisco.com/) Corporation.

