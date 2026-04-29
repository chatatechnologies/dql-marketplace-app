ARG MARKETPLACE_TOOLS_TAG=0.12.15

FROM marketplace.gcr.io/google/c2d-debian11 AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends gettext

# =========================
# COPY INPUTS
# =========================
ADD chart/dql-marketplace /tmp/chart
ADD apptest/deployer/dql-marketplace /tmp/test/chart

ADD schema.yaml /tmp/schema.yaml
ADD apptest/deployer/schema.yaml /tmp/apptest/schema.yaml

# =========================
# BUILD ARGS
# =========================
ARG REGISTRY
ARG TAG
ARG VERSION
ARG PUBLISHED_VERSION
ARG SERVICE_NAME

# =========================
# EXPORT ONCE (IMPORTANT)
# =========================
ENV REGISTRY=$REGISTRY
ENV TAG=$TAG
ENV VERSION=$VERSION
ENV PUBLISHED_VERSION=$PUBLISHED_VERSION
ENV SERVICE_NAME=$SERVICE_NAME

# =========================
# SUBSTITUTE MAIN CHART (SAFE)
# =========================
RUN find /tmp/chart -type f \( -name "*.yaml" -o -name "*.yml" \) -exec \
    sh -c 'envsubst < "$1" > "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;

# =========================
# SUBSTITUTE TEST CHART
# =========================
RUN find /tmp/test/chart -type f \( -name "*.yaml" -o -name "*.yml" \) -exec \
    sh -c 'envsubst < "$1" > "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;

# =========================
# SUBSTITUTE SCHEMA FILES
# =========================
RUN envsubst < /tmp/schema.yaml > /tmp/schema.yaml.new && \
    mv /tmp/schema.yaml.new /tmp/schema.yaml

RUN envsubst < /tmp/apptest/schema.yaml > /tmp/apptest/schema.yaml.new && \
    mv /tmp/apptest/schema.yaml.new /tmp/apptest/schema.yaml

# =========================
# PACKAGE AFTER SUBSTITUTION (CRITICAL)
# =========================
RUN cd /tmp && tar -czvf /tmp/dql-marketplace.tar.gz chart
RUN cd /tmp/test && tar -czvf /tmp/test/dql-marketplace.tar.gz chart

# =========================
# FINAL DEPLOYER IMAGE
# =========================
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_helm:$MARKETPLACE_TOOLS_TAG

COPY --from=build /tmp/dql-marketplace.tar.gz /data/chart/
COPY --from=build /tmp/test/dql-marketplace.tar.gz /data-test/chart/
COPY --from=build /tmp/schema.yaml /data/
COPY --from=build /tmp/apptest/schema.yaml /data-test/

ENV WAIT_FOR_READY_TIMEOUT=6000
ENV TESTER_TIMEOUT=2700