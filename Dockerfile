FROM jenkins/jnlp-slave

ARG packer_version=1.2.5
ARG inspec_version=2.2.61
ARG ansible_version=2.4.*
ARG credstash_version=1.15.*
ARG awscli_version=1.15.*

ENV PACKER_VER=${packer_version}
ENV INSPEC_VER=${inspec_version}
ENV ANSIBLE_VER=${ansible_version}
ENV CREDSTASH_VER=${credstash_version}
ENV AWSCLI_VER=${awscli_version}

USER root

# Enable sudo
RUN apt-get update && apt-get -y install sudo
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Chef
RUN apt-get install -y wget unzip &&\
    wget https://packages.chef.io/files/stable/inspec/${inspec_version}/ubuntu/14.04/inspec_${inspec_version}-1_amd64.deb -O /tmp/inspec.deb &&\
    dpkg -i /tmp/inspec.deb

# Install Virtual Env & Ansible
RUN echo "ansible==${ansible_version} \n\
awscli==${awscli_version} \n\
credstash==${credstash_version}" > /tmp/requirements.txt
RUN apt-get install -y python-pip &&\
    pip install virtualenv &&\
    sudo -H pip install -r /tmp/requirements.txt

# Install Packer
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip -O packer.zip &&\
    unzip packer.zip &&\
    mv packer /usr/bin/packer &&\
    chmod 755 /usr/bin/packer

ENV USER jenkins

USER jenkins

ENTRYPOINT ["jenkins-slave"]
