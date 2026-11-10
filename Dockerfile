FROM alpine:latest

# Install necessary utilities
RUN apk add --no-cache curl unzip

# Download and install Xray-core release
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/') \
    && curl -L -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/download/v${LATEST_VERSION}/Xray-linux-64.zip \
    && unzip /tmp/xray.zip -d /usr/local/bin/ \
    && rm /tmp/xray.zip

# Create configuration directory
RUN mkdir -p /etc/xray

# Copy your configuration file into the container
COPY config.json /etc/xray/config.json

# Railway provides a dynamic PORT environment variable, which we handle or expose
EXPOSE 3000

# Run Xray using the config file
CMD ["xray", "-config", "/etc/xray/config.json"]
