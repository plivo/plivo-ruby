# Change Log

## [4.18.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.18.0) (2021-07-01)
- Add support for Voice MultiPartyCall APIs (includes retry) and XML, validate voice UTs

## [4.17.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.17.0) (2021-06-15)
- Added stir verification param as part of Get CDR and live call APIs response.

## [4.16.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.16.0) (2021-02-08)
- Add support for Regulatory Compliance APIs.

## [4.15.2](https://github.com/plivo/plivo-ruby/releases/tag/v4.15.2) (2021-01-27)
- Fix Call API resource - Set answer_method as Optional param.

## [4.15.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.15.1) (2021-01-06)
- Fix Search Phone Numbers API using City Attribute.

## [4.15.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.15.0) (2020-11-17)
- Add number_priority support for Powerpack API.

## [4.14.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.14.0) (2020-10-30)
- Change lookup API endpoint and response.

## [4.13.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.13.0) (2020-09-30)
- Add support for Lookup API

## [4.12.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.12.0) (2020-09-24)
- Add "public_uri" optional param support for Application API.

## [4.11.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.11.0) (2020-08-25)
- Add Powerpack for mms

## [4.10.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.10.0) (2020-09-04)
- Add ConferenceUuid & CallState for Get Details of a Call API 
- Upgrade faraday & faraday_middleware dependencies

## [4.9.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.9.1) (2020-08-19)
- Internal changes in Phlo for MultiPartyCall component

## [4.9.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.9.0) (2020-07-23)
- Add retries to multiple regions for voice requests.

## [4.8.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.8.1) (2020-06-05)
- Fix Record a Conference API response.

## [4.8.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.8.0) (2020-05-28)
- Add JWT helper functions.

## [4.7.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.7.1) (2020-05-06)
- Fix Send MMS with existing media_ids.

## [4.7.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.7.0) (2020-04-29)
- Add V3 signature helper functions.

## [4.6.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.6.1) (2020-04-02)
- Add nil check for API requests.

## [4.6.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.6.0) (2020-03-31)
- Add application cascade delete support.

## [4.5.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.5.0) (2020-03-30)
- Add Tollfree support for Powerpack

## [4.4.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.4.0) (2020-03-27)
- Add post call quality feedback API support.

## [4.3.5](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.5) (2019-12-28)
- Add Media support

## [4.3.4](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.4) (2019-12-20)
- Add Powerpack support

## [4.3.3](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.3) (2019-12-04)
- Add MMS support

## [4.3.2](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.2) (2019-11-13)
- Add GetInput XML support

## [4.3.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.3.1) (2019-10-16)
- Add SSML support

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
