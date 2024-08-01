ARG MARKETPLACE_TOOLS_TAG
FROM gcr.io/cloud-marketplace-tools/k8s/deployer_envsubst:$MARKETPLACE_TOOLS_TAG

COPY manifest/* /data/manifest/
COPY schema.yaml /data/
COPY pre-install-script.sh .
RUN chmod +x /autoql-pre-install-script.sh

# Provide registry prefix and tag for default values for images.
ARG REGISTRY
ARG TAG
ARG JSON_SECRET
ARG PEM_SECRET
ARG JWT_SECRET

ENV JSON_SECRET=${JSON_SECRET}
ENV PEM_SECRET=${PEM_SECRET}
ENV JWT_SECRET=${JWT_SECRET}

RUN /autoql-pre-install-script.sh \
    && cat /data/schema.yaml \
    | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
    > /data/schema.yaml.new \
    && mv /data/schema.yaml.new /data/schema.yaml

ENV WAIT_FOR_READY_TIMEOUT 2700
ENV TESTER_TIMEOUT 2700

CMD ["sh", "-c", "/pre-install-script.sh"]