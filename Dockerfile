FROM nginxinc/nginx-unprivileged:1.19-alpine
ARG  IMAGE_SOURCE
ARG  VERSION
LABEL org.opencontainers.image.source $IMAGE_SOURCE
# WORKDIR creates directories as a side-effect
WORKDIR /usr/share/nginx/html
USER 1000

# Copy the result of the build into the root of the webserver
COPY build /usr/share/nginx/html

# Set the workdir to be educates-resources so the workshop puller will work
WORKDIR /educates-resources