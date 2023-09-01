# Use an official Docker image as a parent image
FROM docker:20.10-dind

# Install dependencies
RUN apk add --no-cache \
    curl \
    py-pip \
    python-dev \
    libffi-dev \
    openssl-dev \
    gcc \
    libc-dev \
    make

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sh

# Start the Docker daemon
CMD ["dockerd"]
