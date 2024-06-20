The OpenAPI Converter tool is a project developed by Te Whatu Ora Health New Zealand, which can generate an Implementation Guide package into a OpenAPI specification, for use by developers consuming FHIR APIs as well as programmatic validation tools such as API Gateways. The source code for the tool is available on [GitHub](https://github.com/tewhatuora/fhir-openapi-converter).


<img src="./flow.png" alt="Flow" style="width: 100%;">
<br/>

## Tool Onboarding

To use the OpenAPI Converter tool, a `CapabilityStatement` that is an `InstanceOf` the `HnzToolingCapabilityStatement` [profile](./StructureDefinition-hnz-capability-statement.html) resource must be created within an IG package.

### Example

**Add SUSHI dependency on the Digital Tooling package:**

```yaml
dependencies:
  tewhatuora.digitaltooling.ig: 0.0.5
```

**Example fsh to create a CapabilityStatement instance**

```
Instance: ExampleCapabilityStatement
InstanceOf: HnzToolingCapabilityStatement
Usage: #definition
```

The author must provide all of the required fields which are required by the `HnzToolingCapabilityStatement` profile, in order to generate a valid specification which in line with the Te Whatu Ora Health New Zealand API Publishing standards (the SUSHI tool will report errors in conformance to the required CapabilityStatement profile).

For a full example, view the [ExampleCapabilityStatement fsh source file](https://github.com/tewhatuora/hnz-digital-tooling/blob/master/input/fsh/profiles/ExampleCapabilityStatement.fsh), or the [Example Profile](./CapabilityStatement-ExampleCapabilityStatement.html) page.

## Tool features

The OpenAPI Converter tool takes an input of a FHIR Implementation Guide package and uses the profiled `CapabilityStatement` resource to form an OpenAPI v3 specification.

Implementers using this tool must annotate their API using the `CapabilityStatement` resources effectively to best benefit from the tool.

### OpenAPI Paths and Operations

For each FHIR resource annotated, an OpenAPI path is created, based on the resource interactions listed in the `CapabilityStatement`

Example FSH to OpenAPI Path mapping containing all REST operations:

| FSH interaction | OpenAPI Path and Operation | 
|----------|----------|
| `* rest.resource[=].interaction[+].code = #read`  | `GET /Patient/{rid}` |
| `* rest.resource[=].interaction[+].code = #vread`  | `GET /Patient/{rid}/_history/{vid}` |
| `* rest.resource[=].interaction[+].code = #search-type`  | `GET /Patient` |
| `* rest.resource[=].interaction[+].code = #create`  | `POST /Patient` |
| `* rest.resource[=].interaction[+].code = #update`  | `PUT /Patient/{rid}` |
| `* rest.resource[=].interaction[+].code = #patch`  | `PATCH /Patient/{rid}` |
| `* rest.resource[=].interaction[+].code = #delete` | `DELETE /Patient/{rid}` | 


### OpenAPI Schemas

For each FHIR resource defined, the below behaviour is defined for each case

Case 1: no `profile` or `supportedProfile` defined:

```fsh
* rest.resource[+].type = #Patient
* rest.resource[=].interaction[+].code = #read
```

An OpenAPI schema will be generated using the R4 Patient schema.

Case 2: `supportedProfile` defined

```fsh
* rest.resource[+].type = #Patient
* rest.resource[=].supportedProfile[+] = Canonical(ExamplePatientProfile)
* rest.resource[=].interaction[+].code = #read
```

An OpenAPI schema will be generated for the R4 Patient schema, AND a custom schema for the `ExamplePatientProfile`. This is annotated using `anyOf`. Multiple `supportedProfile` are supported.

Case 3: `profile` defined

```fsh
* rest.resource[+].type = #Patient
* rest.resource[=].profile = Canonical(ExamplePatientProfile)
* rest.resource[=].interaction[+].code = #read
```

An OpenAPI schema will be generated for the `ExamplePatientProfile`. The base R4 Patient resource schema will not be generated.

Case 4: `profile` and `supportedProfile` defined

```fsh
* rest.resource[+].type = #Patient
* rest.resource[=].profile = Canonical(ExamplePatientProfile)
* rest.resource[=].supportedProfile = Canonical(ExamplePatientProfile2)
* rest.resource[=].interaction[+].code = #read
```

An OpenAPI schema will be generated for the `ExamplePatientProfile` and `ExamplePatientProfile2`. This is annotated using `anyOf`.

Once the schemas are generated, they are annotated in the OpenAPI operations based on the operation type, for example GET requests will have the schemas annotated in responses, and requests with a requestBody will have the schemas associated.

#### StructureDefinition conversion support
Where an OpenAPI schema is created from a `StructureDefinition` resource in the IG, the following functionality is supported:
- Removes not allowed elements from the schema
- Adds `patternCoding` (CodeableConcepts) as enum values
- Adds `patternBoolean` as an enum value
- Adds `maxItems` for array items where the `StructureDefinition.max` cardinality is defined
- Adds `minItems` for array items where the `StructureDefinition.mix` cardinality is defined

### FHIR Custom Operations
Where custom operations are annotated for the system or type, an OpenAPI path is created for the custom operation. Where the operation mode is `query`, a `GET /${operation}` endpoint will be created. Where the operation mode is `operation`, a `POST /${operation}` endpoint is created. The parameters defined in the custom operation will be annotated in the OpenAPI spec as either query parameters if it is a GET resource, or a FHIR `Parameters` resource in a requestBody for a POST resource.

Case 1: Define a system level operation
```
* rest.operation[+].name = "summary"
* rest.operation[=].definition = Canonical(ExampleSystemOperationDefinition)
```

Case 2: Define a type level operation

```
// Patient resource
* rest.resource[+].type = #Patient
* rest.resource[=].operation[+].name = "summary"
* rest.resource[=].operation[=].definition = Canonical(ExampleQueryOperationDefinition)
* rest.resource[=].operation[+].name = "match"
* rest.resource[=].operation[=].definition = Canonical(ExampleOperationModeOperationDefinition)

```

### Custom headers
Where an API requires HTTP headers to be provided, these can be annotated using an extension on the `HnzToolingCapabilityStatement` resource. These are added to all API operations.

Example fsh:

```
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[+].url = Canonical(HnzCustomHeadersExtension)
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[key].valueString = "Correlation-Id"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[value].valueUri = "https://raw.githubusercontent.com/tewhatuora/schemas/main/fhir-definitions-oas/uuid-definition.json"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[required].valueBoolean = true
```

For each header, a key `valueString` is provided for the header name, and a `valueUri` is provided for the header value. This must be a resolveable uri to an OpenAPI schema defining the value. The required `valueBoolean` defines whether or not this is listed as a required or optional header.

### OpenAPI Examples
Where a schema is created using a `StructureDefinition` resource, if there are examples contained within the IG using this profile, the examples be added as OpenAPI examples to the OpenAPI specification.

### OpenAPI Security
Where the `CapabilityStatement` is annotated using the [R4 Capability Statement Capabilities extension](https://hl7.org/fhir/r4/extension-capabilities.html) and [oAuth uris extension](https://hl7.org/fhir/r4/extension-oauth-uris.html), the OpenAPI operations will be annotated with the appropriate SMART on FHIR scopes.

Case 1: System to System:

Given the below FSH, which defines SMART on FHIR system to system security

```
* rest.security.service = #SMART-on-FHIR
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
* rest.security.extension[=].extension[+].url = "token"
* rest.security.extension[=].extension[=].valueUri = "https://auth.example.com/oauth2/token"
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/capabilities"
* rest.security.extension[=].valueCode = #client-confidential-symmetric
```

Each standard REST operation in the specification will be annotated with the appropriate SMART on FHIR scope, for example, a `POST /Patient` endpoint would be annotated with the `system/Patient.c` scope, and an OpenAPI security scheme will be generated.

Case 2: User and Patient:

```
* rest.security.service = #SMART-on-FHIR
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
* rest.security.extension[=].extension[+].url = "token"
* rest.security.extension[=].extension[=].valueUri = "https://auth.example.com/oauth2/token"
* rest.security.extension[=].extension[+].url = "authorize"
* rest.security.extension[=].extension[=].valueUri = "https://auth.example.com/oauth2/authorize"
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/capabilities"
* rest.security.extension[=].valueCode = #permission-user
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/capabilities"
* rest.security.extension[=].valueCode = #permission-patient
```

Each standard REST operation in the specification will be annotated with the appropriate SMART on FHIR scope, for example, a `POST /Patient` endpoint would be annotated with the `user/Patient.c` scope and `patient/Patient.c`, and an OpenAPI security scheme will be generated.

Case 3: Standard oAuth

```
* rest.security.service = #oAuth
* rest.security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
* rest.security.extension[=].extension[+].url = "token"
* rest.security.extension[=].extension[=].valueUri = "https://auth.example.com/oauth2/token"
```

An OpenAPI security scheme will be generated.
