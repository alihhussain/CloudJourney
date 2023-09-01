# Use an official Docker image as a parent image
FROM docker:20.10-dind

# Install dependencies
RUN update
RUN add bash
RUN add --no-cache curl
RUN curl -L https://aka.ms/InstallAzureCli | bash
RUN az

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sh

# Start the Docker daemon
CMD ["dockerd"]