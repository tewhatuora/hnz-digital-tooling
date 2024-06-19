Profile: HnzToolingCapabilityStatement
Parent: CapabilityStatement
Id: hnz-capability-statement
Title: "Capability Statement profile for use with the Health New Zealand Te Whatu Ora OpenAPI spec converter"
Description: "A CapabilityStatement profile that constrains and documents the Capability Statement to the Health New Zealand Te Whatu Ora OpenAPI spec converter requirements"

* contact 1..1
* contact.name 1..1
* contact.name ^short = "The name of the contact"
* contact.telecom.system = #url
* contact.name ^short = "The url for the contact"
* contact ^short = "The contact details used in the OpenAPI info section"

* version 1..1
* version ^short = "The version of API, displayed in the OpenAPI contact section"

* format 1..1
* format ^short = "The media types supported by the API, e.g. application/json or application/fhir+json"

* extension contains HnzApiSpecBuilderExtension named HnzApiSpecBuilderExtension 1..1

* rest.mode ^short = "The mode of the RESTful interface. A mode of server MUST be provided to generate an OpenAPI spec"
* rest.security.service ^short = "The security service that the server supports, to annotate in the OpenAPI security section"

* rest.operation ^short = "Custom operations that the server supports at at system level. This MUST be provided to generate a OpenAPI path/operation"

* rest.resource 1..*
* rest.resource.type ^short = "The type of resource that the server supports. This MUST be provided to generate OpenAPI paths"

* rest.resource.profile ^short = "The base profile that the resource supports. If not provided, the base resource schema from the FHIR specification will be used"
* rest.resource.supportedProfile ^short = "The profiles that the resource supports. This MUST be provided to generate OpenAPI schemas based on the FHIR profiles, and examples on each resource"
* rest.resource.interaction ^short = "The interactions that the resource supports. This MUST be provided to generate OpenAPI operations"
* rest.resource.searchParam ^short = "The search parameters that the resource supports. This MUST be provided to generate OpenAPI parameters on each resource"
* rest.resource.operation ^short = "Custom operations that the resource supports. This MUST be provided to generate a OpenAPI path/operation"
* rest.resource.operation.name ^short = "The name of the operation that the resource supports"
* rest.resource.operation.definition ^short = "The canonical URL of the operation definition that the resource supports"
