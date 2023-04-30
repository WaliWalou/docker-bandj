# Use the Alpine Linux image as a base
FROM alpine:latest

# Install required dependencies
RUN apk add --no-cache \
    ca-certificates \
    tzdata

# Set the Portainer version
ARG PORTAINER_VERSION=2.18.1

# Download and install the Portainer binary
ADD https://github.com/portainer/portainer/releases/download/${PORTAINER_VERSION}/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz /tmp
RUN tar -xzf /tmp/portainer-${PORTAINER_VERSION}-linux-amd64.tar.gz -C /tmp && \
    mv /tmp/portainer/portainer /usr/local/bin/portainer && \
    chmod +x /usr/local/bin/portainer && \
    rm -rf /tmp/portainer

# Download and install the Docker Compose plugin
ADD https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-linux-x86_64 /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Copy the custom entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Set execution permission to the entrypoint script
RUN chmod +x /entrypoint.sh

# Expose the default Portainer ports
EXPOSE 8000 9000

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
