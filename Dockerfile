FROM jenkins/jnlp-slave

USER root

# Enable sudo
RUN apt-get update && apt-get -y install sudo
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Chef
RUN apt-get install -y wget unzip &&\
    wget https://packages.chef.io/files/stable/inspec/2.2.61/ubuntu/14.04/inspec_2.2.61-1_amd64.deb -O /tmp/inspec.deb &&\
    dpkg -i /tmp/inspec.deb

# Install Virtual Env & Ansible
COPY requirements.txt /tmp/requirements.txt
RUN apt-get install -y python-pip &&\
    pip install virtualenv &&\
    pip install -r /tmp/requirements.txt

# Install Packer
RUN wget https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip -O packer.zip &&\
    unzip packer.zip &&\
    mv packer /usr/bin/packer &&\
    chmod 755 /usr/bin/packer

ENV USER jenkins

ENTRYPOINT ["jenkins-slave"]