#!/bin/bash

set -e

SSH_KEY=""
SSH_PUB_KEY=""
NAMESPACE=""
SSH_CONFIG=""

usage() {
    cat <<EOF
Usage: $0 --ssh-key <path> --ssh-pub-key <path> --namespace <name> --ssh-config <path>

Arguments:
  --ssh-key <path>
      Path to the SSH private key file.

  --ssh-pub-key <path>
      Path to the SSH public key file.

  --namespace <name>
      Kubernetes namespace for the secret.

  --ssh-config <path>
      Path to the SSH config file.

Example:
  $0 --ssh-key /path/to/private_key --ssh-pub-key /path/to/public_key.pub --namespace my-namespace --ssh-config /path/to/ssh_config
EOF
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --ssh-key)
            SSH_KEY="$2"
            shift 2
            ;;
        --ssh-pub-key)
            SSH_PUB_KEY="$2"
            shift 2
            ;;
        --namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        --ssh-config)
            SSH_CONFIG="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done


if [[ -z "$SSH_KEY" ]]; then
    echo "Error: --ssh-key <path> is required."
    usage
fi
if [[ -z "$SSH_PUB_KEY" ]]; then
    echo "Error: --ssh-pub-key <path> is required."
    usage
fi
if [[ -z "$NAMESPACE" ]]; then
    echo "Error: --namespace <name> is required."
    usage
fi
if [[ -z "$SSH_CONFIG" ]]; then
    echo "Error: --ssh-config <path> is required."
    usage
fi


if [[ ! -f "$SSH_KEY" || ! -s "$SSH_KEY" ]]; then
    echo "Error: SSH private key file '$SSH_KEY' is missing or empty."
    exit 1
fi

if [[ ! -f "$SSH_PUB_KEY" || ! -s "$SSH_PUB_KEY" ]]; then
    echo "Error: SSH public key file '$SSH_PUB_KEY' is missing or empty."
    exit 1
fi

if [[ ! -f "$SSH_CONFIG" || ! -s "$SSH_CONFIG" ]]; then
    echo "Error: SSH config file '$SSH_CONFIG' is missing or empty."
    exit 1
fi

# Read and base64 encode files
WTO_SSH_KEY=$(cat "$SSH_KEY" | base64 -w 0)
WTO_SSH_KEY_PUB=$(cat "$SSH_PUB_KEY" | base64 -w 0)
SSH_CONFIG_CONTENT=$(cat "$SSH_CONFIG" | base64 -w 0)


cat <<EOF > git-ssh-key.yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh-key
  namespace: $NAMESPACE
  labels:
    controller.devfile.io/mount-to-devworkspace: 'true'
    controller.devfile.io/watch-secret: 'true'
  annotations:
    controller.devfile.io/mount-as: subpath
    controller.devfile.io/mount-path: /etc/ssh/
type: Opaque
data:
  wto_ssh_key: $WTO_SSH_KEY
  wto_ssh_key.pub: $WTO_SSH_KEY_PUB
  ssh_config: $SSH_CONFIG_CONTENT
EOF


echo "Secret YAML generated: git-ssh-key.yaml"
