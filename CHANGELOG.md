# Change Log

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
