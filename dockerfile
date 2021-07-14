# Pull kubespray image from quay
FROM quay.io/kubespray/kubespray:v2.15.1

# Install packer, unzip, uuid, git
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" &&\
    apt-get update &&\
    apt-get install packer unzip git uuid &&\
    apt-get clean

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/1.0.2/terraform_1.0.2_linux_amd64.zip --output /tmp/terraform.zip &&\
    unzip /tmp/terraform.zip &&\
    mv terraform /usr/bin/ &&\
    rm -f /tmp/*

# Install awscli
RUN pip install awscli