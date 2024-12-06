FROM quay.io/wto/web-terminal-tooling:next
# TODO: Ideally, you want to build this off of wto tooling w/kubedock
# FROM quay.io/<user>/wto-tooling:kubedock-only

USER 0

# Enable epel release repo, required for Fish
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN rpm -ql epel-release

# Install Fish
RUN microdnf install -y fish

# Needed because automount configmap setting $SHELL will break your CDE's if the tooling image doesn't have Fish
ENV SHELL="fish"

USER 1001

# TODO: Add alias for ripgrep and bat?

# TODO: Create fish config ~/.config/fish/config.fish


# TODO: Currently getting the following error:
# Welcome to fish, the friendly interactive shell
# Type help for instructions on how to use fish
# @workspacee2091da8db5d4035-789d4f898d-4zdgb ~> error: Runtime path not available.
# error: Try deleting the directory /tmp/fish. and restarting fish.
## NOTE: I fixed above error by not building ontop of the kubedock image, so maybe kubedock is breaking things?

ENTRYPOINT [ "/entrypoint.sh" ]
