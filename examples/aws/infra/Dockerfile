# JENKINS
FROM jenkins/jenkins:latest
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false -Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc.yaml
USER root

# REGO
RUN curl -L -o /usr/local/bin/opa https://openpolicyagent.org/downloads/v0.50.2/opa_linux_amd64_static
RUN chmod 755 /usr/local/bin/opa

# TERRAFORM
RUN apt-get update
RUN apt-get install -y gnupg software-properties-common wget vim jq
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update
RUN apt-get install -y terraform

# JENKINS CONFIGURATION
COPY casc.yaml /usr/share/jenkins/ref/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --verbose -f /usr/share/jenkins/ref/plugins.txt

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "/tmp/awscliv2.zip"
RUN unzip /tmp/awscliv2.zip -d /tmp
RUN /tmp/aws/install
RUN aws configure set region us-east-1
RUN echo '[default]\n\
aws_access_key_id = test\n\
aws_secret_access_key = test' > /root/.aws/credentials