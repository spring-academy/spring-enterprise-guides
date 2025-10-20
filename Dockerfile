FROM nginxinc/nginx-unprivileged:1.19-alpine
ARG  IMAGE_SOURCE
ARG  VERSION
LABEL org.opencontainers.image.source $IMAGE_SOURCE
# WORKDIR creates directories as a side-effect
WORKDIR /usr/share/nginx/html
COPY --from=0 /usr/src/lab/build/html /usr/share/nginx/html
COPY --from=0 /usr/src/lab/educates/html /usr/share/nginx/html/educates

USER 1000
COPY --from=0 --chown=1000:1000 /usr/src/lab/workshop-resources /tmp/workshop-resources
COPY --from=0 --chown=1000:1000 /usr/src/lab/workshop-resources /educates-resources
WORKDIR /tmp/workshop-resources/apply
ENV VERSION=${VERSION}
RUN for f in *.yaml; do envsubst '${VERSION}' < $f > /educates-resources/apply/$f; done
RUN rm -rf /tmp/workshop-resources
WORKDIR /educates-resources