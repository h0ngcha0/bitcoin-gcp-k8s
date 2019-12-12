# Bitcoin full node on GCP

There are [many reasons](https://blog.keys.casa/why-run-a-node/) to
run a Bitcoin full node. Running it in the cloud has a few extra
benefits:

- A fully indexed Bitcoin full node can take up to 300Gi disk space,
  and non-trivial amount of CPU and memory, which is quite a bit for a
  laptop if it is also used for other daily work. 
- It is easy to access Bitcoin full node from anywhere through multiple
  devices, using standard tooling such as
  [gcloud](https://cloud.google.com/sdk/gcloud/) and
  [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).
- If you want to develop or test a Bitcoin application, it is easy to point
  local development environment to the Bitcoin full node through [port
  forwarding](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/).

Code contained this repository helps to run a Bitcoin full node in
[Google Cloud Platform](https://cloud.google.com/) using [Kubernetes
Engine](https://cloud.google.com/kubernetes-engine/). It can be used
as a starting point to build and deploy Bitcoin powered applications.

## Prerequisit

* [Terraform](https://www.terraform.io/) (>0.12)
* [Google Cloud SDK](https://cloud.google.com/sdk/)

## Setup

1. If you have not setup GCP for your google account already, you can
   try to set it up [here](https://cloud.google.com/gcp/). For new
   users, Google offers 300 USD credits. To start the trial, Google
   requires registration of payment method.
2. After GCP is setup, you can find your billing account id
   [here](https://console.cloud.google.com/billing)
3. Bitcoind RPC requires basic authentication. Use
   [rpcauth.py](rpcauth.py) to generate the `rpcauth` value, as shown below:
   
```
$ ./rpcauth.py username password
String to be appended to bitcoin.conf:
rpcauth=username:6436a49a71eabc219d79c38980be0a54$7bc37525a942213ee5ac1ae8cf7f802616b96bf2dd01a1e0121629be86c5d425
```

4. Go into terraform directory, run

```
terraform init
terraform plan -var 'project_id=YOUR_PROJECT_ID' \
               -var 'project_billing_account=YOUR_BILLING_ACCOUNT_ID_FROM_STEP_2' \
               -var 'bitcoin_rpcauth=YOUR_RPCAUTH_CREATED_FROM_STEP_3' \
               -out plan.out
               
## Confirm the output and then run
terraform apply "plan.out"
```

If everything is executed successfully, a Bitcoin node should be
running in the `bitcoin` namespace in the kubernetes cluster.

