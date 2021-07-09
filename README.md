# provider-terraform-examples

Example configurations that leverage @crossplaneio's [provider-terraform]. This
repository includes the following examples:

* [`migrating-from-terraform`] demonstrates how a platform team can bring an
  existing Terraform configuration under Crossplane management to offer their
  engineers a self-service API, then gradually migrate to using native
  Crossplane resources.
* [`unsupported-resources`] demonstrates how platform teams can use Crossplane
  and provider-terraform to offer their engineers a simple, self service API for
  managing virtual machines, even though Crossplane does not yet have native
  support for major cloud virtual machines.

[provider-terraform]: https://github.com/crossplane-contrib/provider-terraform
[`migrating-from-terraform`]: migrating-from-terraform
[`unsupported-resources`]: unsupported-resources