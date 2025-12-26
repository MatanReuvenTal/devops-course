FROM python:3.9-slim

# 1. Install system tools and the Docker CLI (client)
RUN apt-get update && apt-get install -y docker.io sshpass

# 2. Install Ansible and the Python Docker library
RUN pip install ansible docker

# 3. Set the working directory
WORKDIR /work