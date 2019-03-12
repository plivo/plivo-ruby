# Change Log

## [4.3.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.0) (2019-03-12)
- Add PHLO support
- Add Multi-Party Call triggers

## [4.2-beta1](https://github.com/plivo/plivo-ruby/releases/tag/v4.2-beta1) (2019-03-11)
- Add PHLO support
- Add Multi-Party Call triggers

## [4.1.8](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.8) (2019-02-27)
- Fix log_incoming_messages having no effect while application creation

## [4.1.7](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.7) (2019-02-20)
- Fix responses for all API resources(responses were returning a hash).

## [4.1.6](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.6) (2018-11-26)
- Fix bignum deprecated warning in Ruby 2.4+.

## [4.1.5](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.5) (2018-11-21)
- Add hangup party details to CDR. CDR filtering allowed by hangup_source and hangup_cause_code.
- Add sub-account cascade delete support.

## [4.1.4](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.4) (2018-10-29)
- Add live calls filtering by from, to numbers and call_direction.

## [4.1.3](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.3) (2018-10-01)
- Added Trackable parameter in messages.

## [4.1.2](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.2) (2018-09-18)
- Added parent_call_uuid parameter to filter calls.
- Queued status added for filtering calls in queued status.
- Added log_incoming_messages parameter to application create and update.

## [4.1.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.1) (2018-08-08)
- Upgraded version of faraday_middleware to 0.12.2 which parses YAML safely

## [4.1.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.1.0) (2018-02-26)
- Add Address and Identity resources
- Change a few functions in number-related methods to support the verification flows

## [4.0.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.0.0) (2018-01-18)
- Now supports timeout & proxy (in a non-deprecated way) settings
- A bug fixed (#55)

## [4.0.0.beta.2](https://github.com/plivo/plivo-ruby/releases/tag/v4.0.0.beta.2) (2017-10-24)
- The new SDK works with Ruby >= 2. Tested against 2.0.0, 2.1, 2.2.0, 2.3.0, 2.4.0, 2.5-dev.
- JSON serialization and deserialization is now handled by the SDK
- The API interfaces are consistent and guessable
- Handles pagination automatically when listing all objects of a resource

## [v0.3.19](https://github.com/plivo/plivo-ruby/tree/v0.3.19) (2015-11-24)
- Add `modify_number` function

## [0.3.17](https://github.com/plivo/plivo-ruby/tree/v0.3.17) (2015-07-21)
- Add support for `digitsMatchBLeg` in Dial XML
- `stop_speak_member` function added

## Other changes
- 2013-10-23 Added `stop_speak()`
- 2013-09-25 Added `relayDTMF` to `<Conference>` and `async` to `<DTMF>`
- 2013-08-17 Fix unicode characters only for speak element.
- 2013-08-12 Fix unicode characters only for speak APIs.
- 2013-07-26 Added `XPlivoSignature` header validation.
- 2013-07-21 Added outgoing carrier and carrier routing apis.
- 2013-07-20 Added `recordWhenAlone` to `<Conference>`.
- 2013-07-14 Unicode character support in XML and API.
- 2013-03-15 Added `min_silence` to `<Wait>`.
- 2013-02-23 Pricing API added.
