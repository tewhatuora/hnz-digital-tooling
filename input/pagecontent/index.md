## HNZ Digital Tooling

See [FHIR Artifacts](./artifacts.html) for an overview of the profiles contained in this Implementation Guide.

To use these profiles, a dependency should be added to the source Implementation Guide's `sushi-config.yaml`, such as:

```yaml
dependencies:
  tewhatuora.digitaltooling.ig: 0.0.5
```

To use the OpenAPI generator, a `CapabilityStatement` resource must be created within an IG, which is an `InstanceOf` the `HnzToolingCapabilityStatement` [profile](./StructureDefinition-hnz-capability-statement.html)

Example fsh:

```
Instance: ExampleCapabilityStatement
InstanceOf: HnzToolingCapabilityStatement
Usage: #definition

(details)
```

For a full example, view the [ExampleCapabilityStatement fsh file](https://github.com/tewhatuora/hnz-digital-tooling/blob/master/input/fsh/profiles/ExampleCapabilityStatement.fsh).
