# Pull kubespray image from quay
FROM quay.io/kubespray/kubespray:v2.15.1

# Install packer, unzip, uuid, git
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" &&\
    apt-get update &&\
    apt-get install packer unzip git uuid wget &&\
    apt-get clean

# Install terraform
RUN wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip &&\
    unzip /tmp/terraform.zip &&\
    mv terraform /usr/bin/ &&\
    rm -rf /tmp/*

# Install awscli
RUN pip install awscli

# REMOVE ONCE DEV IS DONE
RUN git clone https://github.com/jmeachum/k8s-auto-deploy.git /k8s-auto-deploy &&\
    chmod +x /k8s-auto-deploy/build.sh