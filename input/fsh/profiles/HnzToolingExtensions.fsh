Extension: HnzApiSpecBuilderExtension
Id: resource-metadata-extension
Title: "Resource Metadata Extension"
Description: "An extension to hold additional metadata for resources such as global headers and license URL."

* extension contains
    globalHeaders 0..* and
    licenseURL 1..1 and
    externalDocs 1..1 and
    licenseName 1..1

* extension[globalHeaders].extension only HnzCustomHeadersExtension
* extension[globalHeaders] ^short = "Global HTTP headers to be added to all operations as request parameters within the OpenAPI specification"

* extension[licenseURL].value[x] only uri
* extension[licenseURL] ^short = "A URL to the license under which the FHIR API is provided."

* extension[licenseName].value[x] only string
* extension[licenseName] ^short = "A name for the license under which the FHIR API is provided."

* extension[externalDocs].value[x] only uri
* extension[externalDocs] ^short = "A URL to the external documentation for this FHIR API."

Extension: HnzCustomHeadersExtension
Id: custom-headers-extension
Title: "HNZ Custom Headers Extension"
Description: "An extension to represent custom headers to be applied globally in an OpenAPI specification."

* extension contains
    key 1..1 and
    value 1..1 and
    required 1..1

* extension[key].value[x] only string
* extension[key] ^short = "The header name. E.g. Request-Context"

* extension[value].value[x] only uri
* extension[value] ^short = "The uri to an OAS schema to apply for the header value"

* extension[required].value[x] only boolean
* extension[required] ^short = "Whether the header is required or optional."
