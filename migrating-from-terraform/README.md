
# Migrating From Terraform

This example demonstrates how you can use provider-terraform to begin your
migration from Terraform to Crossplane. Start by defining a Crossplane
Composite Resource (XR) to provide an opinionated API to your customers - the
engineers you support - then write a composition that satisfies that XR using
your existing Terraform modules. Once self service is working well and you're
familiar with Crossplane, you can seamlessly switch out the Terraform modules
(i.e. the `Workspace` managed resource) for native Crossplane managed resources.

In this example we'll define a `Bucket` composite resource which can be
satisfied by either a `provider-terraform` or `provider-gcp` based composition,
representing the Terraform configuration you're migrating from and the
Crossplane configuration you're migrating to respectively.

> Note that this example uses the Terraform configuration under /tf, which
> includes a GCP project. You'll need to fork this repo, specify your own
> project, and build and push an updated configuration to reference your own
> git repo if you want to try it.

To try this example, first install the configuration:

```console
kubectl crossplane install configuration negz/terraform-examples-migrating-from-terraform:latest
```

Next, apply the Terraform and GCP provider configs. You'll need to make sure to
create a secret containing your Google credentials (in JSON form), and ensure
those credentials have IAM access to create GCS buckets.

```console
# Apply your credentials.
kubectl apply -f gcp-credentials-secret.yaml

# Apply the provider configs
kubectl apply -f providerconfig-terraform.yaml
kubectl apply -f providerconfig-gcp.yaml
```

Once you have your `ProviderConfigs` setup you can create a bucket by applying
`bucket.yaml`:

```console
kubectl apply -f vm.yaml
```

After a minute or two you should have a bucket! Try the following
commands to inspect its status.

```console
# The 'user facing' bucket claim.
kubectl describe bucket

# The behind the scenes CompositeBucket and the Terraform Workspace of which it is
# composed.
kubectl describe compositebucket
kubectl describe workspace
```

You should now have a bucket provisioned using Terraform! Now when you are ready
you can start provisioning buckets using the native Crossplane GCP provider
instead.

First delete your existing bucket:

```console
kubectl delete -f bucket.yaml
```

Then edit it and change the provider composition selector from 'terraform' to
'gcp' and apply the new bucket:

```console
vim bucket.yaml
kubectl apply -f bucket.yaml
```

Now if you inspect your CompositeBucket you should see that it is composed of
a GCP storage bucket, not a Terraform workspace.

```console
kubectl describe compositebucket
```

That's it! You just migrated your bucket from Terraform to a native provider.
As an app developer supported by your platform team, you only had to know to ask
for a GCP provider instead of a Terraform provider; everything else about the
bucket management flow is identical.

Take a look at
[`package/composition-terraform.yaml`](package/composition-terraform.yaml) and
[`package/composition-native.yaml`](package/composition-native.yaml) to get an
idea of how this example works under the hood.
