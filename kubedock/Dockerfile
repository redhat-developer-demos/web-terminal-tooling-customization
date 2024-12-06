FROM quay.io/wto/web-terminal-tooling:next
# TODO: Ideally, you want to build this off of wto tooling w/extra tooling
# FROM quay.io/<user>/wto-tooling:extra-tooling

USER 0

# Install podman
RUN microdnf -y install podman && \
    microdnf -y clean all

# Add kubedock
ENV KUBEDOCK_VERSION 0.17.1
ENV KUBECONFIG=/home/user/.kube/config
RUN curl -L https://github.com/joyrex2001/kubedock/releases/download/${KUBEDOCK_VERSION}/kubedock_${KUBEDOCK_VERSION}_linux_amd64.tar.gz | tar -C /usr/local/bin -xz --no-same-owner \
    && chmod +x /usr/local/bin/kubedock
COPY --chown=0:0 kubedock_setup.sh /usr/local/bin/kubedock_setup

# Configure Podman wrapper
ENV PODMAN_WRAPPER_PATH=/usr/bin/podman.wrapper
ENV ORIGINAL_PODMAN_PATH=/usr/bin/podman.orig
COPY --chown=0:0 podman-wrapper.sh "${PODMAN_WRAPPER_PATH}"
RUN mv /usr/bin/podman "${ORIGINAL_PODMAN_PATH}"

# Ensure podman wrapper is on PATH
ENV PATH="/home/user/.local/bin:$PATH"

COPY --chown=0:0 entrypoint.sh /


# Enable kubedock by default
# Could also be done with an automount configmap
ENV KUBEDOCK_ENABLED=true


USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
