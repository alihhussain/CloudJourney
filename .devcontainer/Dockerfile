# Use an official Docker image as a parent image
FROM docker:24.0.5-dind-alpine3.18

RUN \
  apk update && \
  apk add bash py-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev make && \
  pip --no-cache-dir install -U pip && \
  pip --no-cache-dir install azure-cli && \
  apk del --purge build

# Start the Docker daemon
CMD ["dockerd"]
