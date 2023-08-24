# Change Log
## [4.48.0](https://github.com/plivo/plivo-ruby/tree/v4.48.0) (2023-08-25)
**Feature - Added New Param 'carrier_fees', 'carrier_fees_rate', 'destination_network' in Get Message and List Message APIs**
- Added new params on message get and list response

## [4.47.0](https://github.com/plivo/plivo-ruby/tree/v4.47.0) (2023-08-03)
**Feature - DLT parameters**
- Added new params `DLTEntityID`, `DLTTemplateID`, `DLTTemplateCategory` to the [send message API](https://www.plivo.com/docs/sms/api/message/send-a-message/)
- Added new params `DLTEntityID`, `DLTTemplateID`, `DLTTemplateCategory` to the response for the [list all messages API](https://www.plivo.com/docs/sms/api/message/list-all-messages/) and the [get message details API](https://www.plivo.com/docs/sms/api/message#retrieve-a-message)

## [4.46.0](https://github.com/plivo/plivo-ruby/tree/v4.46.0) (2023-06-28)
**Feature - Audio Streaming**
- Added functionality to start, stop and fetch audio streams
- Added functionality to create stream XML

## [4.45.0](https://github.com/plivo/plivo-ruby/tree/v4.45.0) (2023-05-02)
**Feature - CNAM Lookup**
- Added New Param `cnam_lookup` in to the response of the [list all numbers API], [list single number API]
- Added `cnam_lookup` filter to AccountPhoneNumber - list all my numbers API.
- Added `cnam_lookup` parameter to buy number[Buy a Phone Number]  to configure CNAM Lookup while buying a US number
- Added `cnam_lookup` parameter to update number[Update an account phone number] to configure CNAM Lookup while buying a US number


## [4.44.0](https://github.com/plivo/plivo-ruby/tree/v4.38.2) (2023-03-16)
**Feature : Added new param in getCallDetail api**
- From now on we can see CNAM(Caller_id name) details at CDR level.

## [4.43.0](https://github.com/plivo/plivo-ruby/tree/v4.43.0) (2023-05-29)
**Feature - Recording API changes**
- Added `monthly_recording_storage_amount`, `recording_storage_rate`, `rounded_recording_duration`, and `recording_storage_duration` parameters to the response for [get single recording API](https://www.plivo.com/docs/voice/api/recording#retrieve-a-recording) and [get all recordings API](https://www.plivo.com/docs/voice/api/recording#list-all-recordings)
- Added `recording_storage_duration` parameter as a filter option for [get all recordings API](https://www.plivo.com/docs/voice/api/recording#list-all-recordings)

## [4.42.0](https://github.com/plivo/plivo-ruby/tree/v4.42.0) (2023-05-04)
**Adding new attribute - 'renewalDate' in Get Number and List Number APIs**
- Add New Param `renewalDate` to the response of the [list all numbers API], [list single number API]
- Add 3 new filters to AccountPhoneNumber - list all my numbers API:`renewal_date`, `renewal_date__gt`, `renewal_date__gte`,`renewal_date__lt` and `renewal_date__lte` (https://www.plivo.com/docs/numbers/api/account-phone-number#list-all-my-numbers)

## [4.41.0](https://github.com/plivo/plivo-ruby/tree/v4.41.0) (2023-04-25)
**Adding new attribute - 'replaced_sender' in Get Message and List Message APIs**
- Add `replaced_sender` to the response for the [list all messages API](https://www.plivo.com/docs/sms/api/message/list-all-messages/) and the [get message details API](https://www.plivo.com/docs/sms/api/message#retrieve-a-message)

## [4.40.0](https://github.com/plivo/plivo-ruby/tree/v4.37.0) (2023-04-11)
**Feature - Added New Param 'source_ip' in GetCall and ListCalls**
- Add `source_ip` to the response for the [retrieve a call details API](https://www.plivo.com/docs/voice/api/call#retrieve-a-call) and the [retreive all call details API](https://www.plivo.com/docs/voice/api/call#retrieve-all-calls)

## [4.39.0](https://github.com/plivo/plivo-ruby/tree/v4.39.0) (2023-03-17)
**Adding new attribute - 'created_at' in List Profiles, Get Profile, List Brands, Get Brand, List Campaigns and Get Campaign APIs**
- dding new attribute - 'created_at' in List Profiles, Get Profile, List Brands, Get Brand, List Campaigns and Get Campaign APIs

## [4.38.1](https://github.com/plivo/plivo-ruby/tree/v4.38.1) (2023-03-06)
**Bug fix on create message**
- Bulk send message fix

## [4.38.0](https://github.com/plivo/plivo-ruby/tree/v4.38.0) (2023-03-03)
**Adding new attribute - 'is_domestic' in Get Message and List Message APIs**
- Add `is_domestic` to the response for the [list all messages API](https://www.plivo.com/docs/sms/api/message/list-all-messages/) and the [get message details API](https://www.plivo.com/docs/sms/api/message#retrieve-a-message)

## [4.37.1](https://github.com/plivo/plivo-ruby/tree/v4.37.1) (2023-02-23)
**Bug fix on Messaging object **
- 
## [4.37.0](https://github.com/plivo/plivo-ruby/tree/v4.37.0) (2023-02-23)
**Feature - Enhance MDR filtering capabilities **
- Added new fields on MDR object response

## [4.37.0](https://github.com/plivo/plivo-ruby/tree/v4.37.0) (2023-02-06)
**Feature - Added New Param 'source_ip' in GetCall and ListCalls**
- Add `source_ip` to the response for the [retrieve a call details API](https://www.plivo.com/docs/voice/api/call#retrieve-a-call) and the [retreive all call details API](https://www.plivo.com/docs/voice/api/call#retrieve-all-calls)

## [4.36.0](https://github.com/plivo/plivo-ruby/tree/v4.36.0) (2022-01-25)
**Adding new attribute - 'requester_ip' in Get Message and List Mssage APIs**
- Add `requester_ip` to the response for the [list all messages API](https://www.plivo.com/docs/sms/api/message/list-all-messages/) and the [get message details API](https://www.plivo.com/docs/sms/api/message#retrieve-a-message)

## [4.35.0](https://github.com/plivo/plivo-ruby/tree/v4.35.0) (2022-01-18)
**Adding new attribute - 'message_expiry' in Send Message API**
- Added new attribute - message_expiry in Send Message API

## [4.34.0](https://github.com/plivo/plivo-ruby/tree/v4.34.0) (2022-12-16)
**10DLC: Update Campaign API**
- Added Update Campaign API

## [4.33.0](https://github.com/plivo/plivo-ruby/tree/v4.33.0) (2022-12-06)
**10DLC: Delete Campaign and Brand API**
- Added Delete campaign and brand API

## [4.32.0](https://github.com/plivo/plivo-ruby/tree/v4.32.0) (2022-11-03)
**10DLC: Brand Usecase API**
- Added Brand Usecase API

## [4.31.0](https://github.com/plivo/plivo-ruby/tree/v4.31.0) (2022-10-14)
**Adding new attributes to Account PhoneNumber object**
-Added 3 new keys to AccountPhoneNumber object:`tendlc_registration_status`, `tendlc_campaign_id` and `toll_free_sms_verification` (https://www.plivo.com/docs/numbers/api/account-phone-number#the-accountphonenumber-object)
-Added 3 new filters to AccountPhoneNumber - list all my numbers API:`tendlc_registration_status`, `tendlc_campaign_id` and `toll_free_sms_verification` (https://www.plivo.com/docs/numbers/api/account-phone-number#list-all-my-numbers)

## [4.30.2](https://github.com/plivo/plivo-ruby/tree/v4.30.2) (2022-09-28)
**10DLC: Campaign request**
- Added more attributes to create campaign request

## [4.30.1](https://github.com/plivo/plivo-ruby/tree/v4.30.1) (2022-09-20)
**stability - faraday upgrade**
- faraday version upgrade

## [4.30.0](https://github.com/plivo/plivo-ruby/tree/v4.30.0) (2022-08-26)
**Feature - 10DLC APIs**
- Added new 10DLC APIs

## [4.29.0](https://github.com/plivo/plivo-ruby/tree/v4.29.0) (2022-08-01)
**Feature - Token Creation**
- `JWT Token Creation API` added functionality to create a new JWT token.

## [4.28.0](https://github.com/plivo/plivo-ruby/tree/v4.28.0) (2022-07-11)
**Feature - STIR Attestation**
- Add stir attestation param as part of Get CDR and Get live call APIs Response

## [4.27.1](https://github.com/plivo/plivo-ruby/tree/v4.27.1) (2022-06-30)
- `from_number`, `to_number` and `stir_verification` added to filter param [Retrieve all calls] (https://www.plivo.com/docs/voice/api/call#retrieve-all-calls)

## [4.27.0](https://github.com/plivo/plivo-ruby/tree/v4.27.0) (2022-05-05)
**Feature - List all recordings**
- `from_number` and `to_number` added to filter param [List all recordings](https://www.plivo.com/docs/voice/api/recording#list-all-recordings)
- `record_min_member_count` param added to [Add a participant to a multiparty call using API](https://www.plivo.com/docs/voice/api/multiparty-call/participants#add-a-participant)

## [4.26.0](https://github.com/plivo/plivo-ruby/tree/v4.26.0) (2022-03-24)
**Feature - DialElement**
- `confirmTimeout` parameter added to [The Dial element](https://www.plivo.com/docs/voice/xml/dial/)

## [4.25.1](https://github.com/plivo/plivo-ruby/tree/v4.25.1) (2022-02-02)
**Bugfix - Recording**
- Fix for Start Recording API response issue

## [4.25.0](https://github.com/plivo/plivo-ruby/tree/v4.25.0) (2022-01-27)
**Features - MPCStartCallRecording**
- parameter name change from statusCallback to recordingCallback

## [4.24.0](https://github.com/plivo/plivo-ruby/tree/v4.24.0) (2021-12-14)
**Features - Voice**
- Routing SDK traffic through Akamai endpoints for all the [Voice APIs](https://www.plivo.com/docs/voice/api/overview/)

## [4.23.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.23.0) (2021-12-02)
**Features - Messaging: 10 DLC**
- 10DLC API's for brand and campaign support.

## [4.22.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.22.0) (2021-11-11)
**Features - Voice: Multiparty call**
- The [Add Multiparty Call API](https://www.plivo.com/docs/voice/api/multiparty-call/participants#add-a-participant) allows for greater functionality by accepting options like `start recording audio`, `stop recording audio`, and their HTTP methods.
- [Multiparty Calls](https://www.plivo.com/docs/voice/api/multiparty-call/) now has new APIs to `stop` and `play` audio.

## [4.21.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.21.0) (2021-10-11)
**Features - Messaging**
- This version includes advancements to the Messaging Interface that deals with the [Send SMS/MMS](https://www.plivo.com/docs/sms/api/message#send-a-message) interface, Creating a standard structure for `request/input` arguments to make implementation easier and incorporating support for the older interface.

  Example for [send SMS](https://github.com/plivo/plivo-ruby#send-a-message)

## [4.20.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.20.0) (2021-08-04)
- Added continue speak XML element support.

## [4.19.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.19.0) (2021-07-19)
- Add support for Voice MultiPartyCall APIs (includes retry) and XML, validate voice UTs

## [4.18.0](https://github.com/plivo/plivo-ruby/releases/tag/v4.18.0) (2021-07-13)
- Power pack ID has been included to the response for the [list all messages API](https://www.plivo.com/docs/sms/api/message/list-all-messages/) and the [get message details API](https://www.plivo.com/docs/sms/api/message#retrieve-a-message).
- Support for filtering messages by Power pack ID has been added to the [list all messages API](https://www.plivo.com/docs/sms/api/message#list-all-messages).

## [4.17.1](https://github.com/plivo/plivo-ruby/releases/tag/v4.17.1) (2021-06-18)
- **WARNING**: Remove total_count field from meta data for list MDR response

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
