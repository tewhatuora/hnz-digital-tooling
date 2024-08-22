Invariant: contact-url-invariant
Description: "The CapabilityStatement must have at least one contact where the system is a url."
Expression: "contact.telecom.where(system = 'url').exists()"
Severity: #error
