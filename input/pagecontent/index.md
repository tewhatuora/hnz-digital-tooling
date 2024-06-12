## HNZ Digital Tooling

See [FHIR Artefacts](./artifacts.html) for an overview of the profiles contained in this Implementation Guide.

To use these profiles, a dependency should be added to the source Implementation Guide's `sushi-config.yaml`, such as:

```yaml
dependencies:
  tewhatuora.digitaltooling.ig:
    id: tewhatuora.digitaltooling.ig
    uri: https://implementation-guides-uat.digital.health.nz/hnz-digital-tooling/package.tgz
    version: 0.0.1
```