# Jenkins JNLP Slave Sandbox

Base image for running Jenkin Jobs. This image has the Jenkins agent enabled with sudo access enabled. This allows maximum flexibility to modify the container to suits their needs. This is made for initial run of Jenkin Jobs. Eventuality users are expect to create their own docker images with their modifications baked in.

# Command Snippets

Deploying the image

```

./push.sh --tag <image_tag> --namespace <namespace> --registry <registry_url> 

# Example to `docker.rt.sec.samsung.net`
./push.sh --tag latest --namespace srca-cpto --registry docker.rt.sec.samsung.netx

```