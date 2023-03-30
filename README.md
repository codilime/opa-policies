# opa-policies

Repository contains examples of **policy as code** with the use of OPA (Open Policy Agent).

## Examples

### Local file

Initialize Terraform:

```
cd examples/local-file/infra
terraform init
```

Prepare Terraform plan in JSON format in 2 steps:

```
terraform plan --out tfplan.binary
terraform show -json tfplan.binary > tfplan.json
```

or use below command:

```
terraform plan --out tfplan.binary && terraform show -json tfplan.binary > tfplan.json
```

Execute Rego policy for generated plan to get final result and score:

```
opa exec --decision terraform/analysis/allow --bundle ../policy tfplan.json
opa exec --decision terraform/analysis/score --bundle ../policy tfplan.json
```

or use below command to get full result:

```
opa exec --decision terraform/analysis --bundle ../policy tfplan.json
```

In order to execute Sentinel policy, prepare JSON in differet place:

```
mkdir ../policy/test/terraform_basic
terraform plan --out tfplan.binary && terraform show -json tfplan.binary > ../policy/test/terraform_basic/tfplan.json
terraform plan --out tfplan.binary && terraform show -no-color tfplan.binary > ../policy/test/terraform_basic/tfplan.hcl
```

and execute Sentinel policy:

```
cd ../policy
sentinel test terraform_basic.sentinel
```

### AWS Lambda

1. Install prerequisites:

[LocalStack](https://docs.localstack.cloud/get-started/#localstack-cli):

```
docker run -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```

[Jenkins](https://hub.docker.com/_/jenkins):

```
current_directory=`pwd`
cd examples/aws/infra
mkdir jenkins
docker run --name jenkins-opa-tf -p 8080:8080 -p 50000:50000 -v $current_directory/examples/aws/infra/jenkins:/var/jenkins_home -v $current_directory/examples/aws:/usr/src/aws jenkins/jenkins
```

[OPA](https://www.openpolicyagent.org/docs/latest/#running-opa):

```
docker exec -it jenkins-opa-tf bash
cd
curl -L -o opa https://openpolicyagent.org/downloads/v0.50.2/opa_linux_amd64_static
```

[Terraform plugin for Jenkins](https://plugins.jenkins.io/terraform/)

2. Deploy infrastructure:

```
cd examples/aws/infra
terraform init
terraform apply -auto-approve
```

3. Verify deplyoment:


On Jenkins container:

```
docker exec -it jenkins-opa-tf bash
jenkins@4aa879681c79:/$ ls -al /usr/src/aws
```

On host machine:

```
aws --endpoint-url=http://localhost:4566 s3 ls
aws --endpoint-url=http://localhost:4566 s3 ls s3://localstack-s3-opa-example
```

4. Destroy deployment:

```
terraform apply -auto-approve -destroy
```

## Links

* [OPA (Open Policy Agent) - Terraform](https://www.openpolicyagent.org/docs/latest/terraform/)
* [Defining OPA Policies](https://developer.hashicorp.com/terraform/cloud-docs/policy-enforcement/opa)
* [Validate Infrastructure and Enforce OPA Policies](https://developer.hashicorp.com/terraform/tutorials/cloud/validation-enforcement)
* [Pre-deployment Policy Checks for Terraform using OPA (Open Policy Agent)](https://medium.com/airwalk/pre-deployment-policy-checks-for-terraform-using-opa-open-policy-agent-96e2ae60f9f5)
* [The Rego Playground](https://play.openpolicyagent.org/)
* [Rego - How Do I Write Policies?](https://www.openpolicyagent.org/docs/v0.13.5/how-do-i-write-policies/)
* [What Is Policy-as-Code?](https://www.paloaltonetworks.com/cyberpedia/what-is-policy-as-code)
* [Sentinel - Policy as Code](https://docs.hashicorp.com/sentinel/concepts/policy-as-code)
* [What is Policy-as-Code? An Introduction to Open Policy Agent](https://blog.gitguardian.com/what-is-policy-as-code-an-introduction-to-open-policy-agent/)
* [AWS Prescriptive Guidance - OPA and Rego](https://docs.aws.amazon.com/prescriptive-guidance/latest/saas-multitenant-api-access-authorization/abac-examples.html)
