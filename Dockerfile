FROM alpine AS builder
# Install oc commandline tool
ARG OPENSHIFT_CLIENT_TOOLS_DOWNLOAD_URL
# Install svcat CLI tool cf. https://svc-cat.io/docs/install/#linux
ARG SERVICE_CATALOG_CLI_DOWNLOAD_URL
ARG KUBECTL_DOWNLOAD_BASE
ARG KUBECTL_DOWNLOAD_TAIL
ARG KUBECTL_RELEASE
#
COPY get_helm.sh /tmp/
#
RUN apk update && apk add openssl gettext curl
#
RUN sh /tmp/get_helm.sh
RUN curl -L $OPENSHIFT_CLIENT_TOOLS_DOWNLOAD_URL | tar xvz -C /usr/local/bin/ --strip-components=1
RUN curl -sLO $SERVICE_CATALOG_CLI_DOWNLOAD_URL && chmod +x ./svcat && mv svcat /usr/local/bin/
RUN curl -sL $KUBECTL_DOWNLOAD_BASE/$(curl -s $KUBECTL_RELEASE)/$KUBECTL_DOWNLOAD_TAIL -o /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl
#
FROM alpine

COPY --from=builder /usr/local/bin /usr/local/bin
