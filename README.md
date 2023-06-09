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

### AWS S3 on Localstack

1. Deploy environment with Localhost, Jenkins, Terraform, Rego and AWS CLI tool installed by Docker Compose:

```
cd examples/aws/infra
docker build -t jenkins:jcasc .
docker-compose up -d
```

After opening [http://localhost:8080/](http://localhost:8080/) and authenticating to Jenkins using login ``admin`` and password ``admin123``, it can be also checked, that there is already project configured:
- name: ``opa-policies``
- type of project: ``pipeline``
- repository - local git: ``file:///usr/local/src/opa-policies``
- branch: ``main``
- pipeline: ``from SCM``
- script path: ``examples/aws/infra/Jenkinsfile``

2. Execute Jenkins pipeline ``opa-policies`` and verify deplyoment on Jenkins container:

```
docker exec -it jenkins bash
aws --endpoint-url=http://localstack:4566 s3 ls
aws --endpoint-url=http://localstack:4566 s3 ls s3://localstack-s3-opa-example
```

3. Destroy deployment:

```
docker exec -it jenkins bash
cd /var/jenkins_home/workspace/opa-policies/examples/aws/infra
terraform apply -auto-approve -destroy
exit

docker compose stop
docker compose rm
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
* [LocalStack](https://docs.localstack.cloud/get-started/#localstack-cli):
* [Jenkins](https://hub.docker.com/_/jenkins), [Jenkins as a code](https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code), [Jenkins Job DSL](https://jenkinsci.github.io/job-dsl-plugin/#method/javaposse.jobdsl.dsl.helpers.workflow.WorkflowDefinitionContext.cpsScm):
* [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa):
* [Terraform plugin for Jenkins](https://plugins.jenkins.io/terraform/)
