require "rubygems"
require "plivo"

include Plivo
include Plivo::Exceptions

AUTH_ID = ""
AUTH_TOKEN = ""

client = RestClient.new(AUTH_ID, AUTH_TOKEN)

# if credentials are stored in the PLIVO_AUTH_ID and the PLIVO_AUTH_TOKEN environment variables
# then initialize client as:
# client = RestClient.new

# 1. EndUSers
begin
  resp = client.end_users.create('Sample First Name',
   'Sample last name',
   'individual')
  puts resp
rescue PlivoRESTError => e
  puts "Exception: " + e.message
end


# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "end_user_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "name": "Sample First Name",
#   "last_name": 'Sample last name',
#   "end_user_type": 'individual',
#   "created_on": '2021-02-08T05:28:49.238152984Z',
#   "message": "created"
# }

# 2. Compliance Document Type
begin
    resp = client.compliance_document_types.get('6264e9ee-5826-4f9a-80ce-00b00f7a6c0c')
    puts resp
  rescue PlivoRESTError => e
    puts "Exception: " + e.message
  end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "document_type_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "document_name": "Address Information",
#   "description": 'End User Residential Address information',
#   "information": [
#      {
#         "enums": [
#             "Water",
#             "Electricity",
#             "Gas",
#             "Property Rental",
#             "Others"
#         ],
#         "field_name": "type_of_utility",
#         "field_type": "enum",
#         "friendly_name": "Type of Utility"
#      }
#   ],
#   "proof_required": "Scanned copy of the Bill",
#   "created_at": '2018-11-03 19:32:33.240504+00:00'
# }

# 3. Compliance Documents
begin
    resp = client.compliance_documents.list(
        limit: 5,
        offset: 0,
        document_type_id: '15d48097-6fd6-4bbc-97ee-0c3dd0a8fe1a',
        end_user_id: '4493840308')
    puts resp
  rescue PlivoRESTError => e
    puts "Exception: " + e.message
  end

# Response
#  {
#    "alias": "test alias",
#    "api_id": "3cfabf1a-6579-11eb-b408-0242ac110005",
#    "created_at": "2021-02-02 08:08:10.312992 +0000 UTC",
#    "document_id": "4a9599cc-c58c-4804-8c04-1d4918cb6df7",
#    "document_type_id": "be903190-cc96-4fd8-b3cd-97832fe7c086",
#    "end_user_id": "652e1445-1657-4a80-972f-6dbd467b00b5",
#    "meta_information": {
#        "use_case_description": "test"
#    }
#}

# 4. Compliance Requirements
begin
    resp = client.compliance_requirements.list(
        country_iso2: 'ES',
        end_user_type: 'business',
        number_type: 'local')
    puts resp
  rescue PlivoRESTError => e
    puts "Exception: " + e.message
  end

# Response:
#{
#   "acceptable_document_types": [
#      {
#         "acceptable_documents": [
#            {
#               "document_type_id": "e68cf5fe-cea0-4b6c-a2b1-bef1d9add467",
#               "document_type_name": "Address Information"
#            }
#          ],
#          "name": "End User Address Details",
#          "scope": "local"
#      },
#      {
#         "acceptable_documents": [
#            {
#               "document_type_id": "e9b0b6fb-fd2f-44c1-9428-ee69afbd808b",
#               "document_type_name": "Utility Bill"
#            }
#          ],
#          "name": "Proof of Address ",
#          "scope": "local"
#        }
#    ],
#    "api_id": "75ea8886-6499-11eb-ad59-0242ac110005",
#    "compliance_requirement_id": "4ae473b0-f154-41a4-aba8-ab76be12f27f",
#    "country_iso2": "ES",
#    "end_user_type": "individual",
#    "number_type": "local"
#}

# 5. Compliance Applications
begin
    resp = client.compliance_applications.create(
        alias_: 'test',
        compliance_requirement_id: '4ae473b0-f154-41a4-aba8-ab76be12f27f',
        end_user_type: 'individual'
        end_user_id: 'f7ba78e0-1d31-4f75-842c-cd2f91334d9f',
        document_ids: ["a663bc92-5c8e-4e95-80d5-ba75d3569a98","4a9599cc-c58c-4804-8c04-1d4918cb6df7"],
        country_iso2: 'FR',
        number_type: 'mobile'
    )
    puts resp
  rescue PlivoRESTError => e
    puts "Exception: " + e.message
  end

# Response:
# {
#   "api_id": "36989807-a76f-4555-84d1-9dfdccca7a80",
#   "alias": "test",
#   "compliance_application_id": "7c83fd87-fb5d-4a88-bde0-7c96da35f1e6",
#   "compliance_requirement_id": "4ae473b0-f154-41a4-aba8-ab76be12f27f",
#   "country_iso2": "FR",
#   "documents": [],
#   "end_user_id": "f7ba78e0-1d31-4f75-842c-cd2f91334d9f",
#   "end_user_type": "individual",
#   "message": "created",
#   "number_type": "local",
#   "status": "draft",
#   "created_at": '2021-02-08T19:32:33.240504+00:00'
# }
