# Unsupported Crossplane Resources

This example demonstrates how provider-terraform can allow Crossplane to compose
resources that are not yet supported by Crossplane, but that are supported by
Terraform.

In this somewhat contrived example we'll use a Google Compute Engine machine -
as of the time of writing Crossplane's native provider-gcp does not yet support
these. In a real world scenario provider-terraform would likely be most useful
to folks who are using Crossplane to manage most of their infrastructure, but
who are waiting on native support for a handful of resources.

To try this example, first install the configuration:

```console
kubectl crossplane install configuration negz/terraform-examples-unsupported-resource:latest
```

Next, apply the Terraform `ProviderConfig`. You'll need to make sure to create
a secret containing your Google credentials (in JSON form), and ensure those
credentials have IAM access to create GCE machines. You'll also need to update
the Google project to one you control.

```console
# Specify your Google project
vim providerconfig.yaml

# Apply your credentials.
kubectl apply -f gcp-credentials-secret.yaml

# Apply the provider config
kubectl apply -f providerconfig.yaml
```

Once you have your `ProviderConfig` setup the final step is to create a virtual
machine by applying `vm.yaml`:

```console
kubectl apply -f vm.yaml
```

After a minute or two you should have a virtual machine! Try the following
commands to inspect its status.

```console
# The 'user facing' VM claim.
kubectl describe vm

# The behind the scenes CompositeVM and the Terraform Workspace of which it is
# composed.
kubectl describe compositevm
kubectl describe workspace
```

Take a look at [`package/composition.yaml`](package/composition.yaml) to get an
idea of how this example works under the hood.