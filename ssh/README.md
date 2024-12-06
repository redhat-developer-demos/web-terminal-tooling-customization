# Mounting your SSH key to a web terminal

## Using the ssh-secret-creator script

You can use the `ssh-secret-creator.sh` script from this repository to create a Kubernetes secret that will automatically mount your SSH key and SSH public key to your web terminals in the namespace of your choice. 

### Usage
```bash
./ssh-secret-creator.sh --ssh-key <path> --ssh-pub-key <path> --ssh-config <path>  --namespace <name>
```

#### Arguments

- **`--ssh-key <path>`**  
  Path to your SSH private key.

- **`--ssh-pub-key <path>`**  
  Path to your SSH public key.

- **`--namespace <name>`**  
   Namespace for the secret. **Note:** only web terminals created in the same namespace as the secret will be able to use your SSH key.

- **`--ssh-config <path>`**  
  Path to the SSH config file.

### Example

Here's an example on how to use the script:

```bash
./ssh-secret-creator.sh --ssh-key ~/.ssh/id_rsa --ssh-pub-key ~/.ssh/id_rsa.pub --ssh-config ./ssh_config --namespace aobuchow-dev
```
This will generate a secret named git-ssh-key.yaml that contains:

- The SSH private key from `~/.ssh/id_rsa`
- The SSH public key from `~/.ssh/id_rsa.pub`
- The ssh_config from this repository

Once your `git-ssh-key.yaml` secret is created, you can apply it to your cluster with:
```bash
oc apply -f ./git-ssh-key.yaml
```

The secret will be created in the specified namespace (`aobuchow-dev` in this example).

Once applied, your web terminal will have the following mounted:
- SSH private key at `/etc/ssh/wto_ssh_key`
- SSH public key at `/etc/ssh/wto_ssh_key.pub`
- The repository’s ssh_config file will overwrite the default `/etc/ssh/ssh_config`


## Manual creation of SSH key for git cloning

Prerequisites:

-  An SSH keypair, with the public key uploaded to the Git provider, that stores your repository.
    - The steps below assume the following environment variables are set:
    - `$SSH_KEY`: path on disk to private key for SSH keypair (e.g. `~/.ssh/id_ed25519`)
    - `$SSH_PUB_KEY`: path on disk to public key for SSH keypair (e.g. `~/.ssh/id_ed25519.pub`)
    - `$NAMESPACE`: namespace where workspaces using the SSH keypair will be started.

Process:

1. Create a `ssh_config` file that will be mounted to `/etc/ssh/ssh_config` in workspaces to configure SSH to use the mounted keys:

```bash
cat <<EOF > /tmp/ssh_config
host *
  IdentityFile /etc/ssh/wto_ssh_key
  StrictHostKeyChecking = no
EOF
```

**Note:** The `/ssh/` directory of this repository already has a `ssh_config` file created for you to use.

2. Create a secret in the namespace where your web terminal will be started. The secret stores the SSH keypair and configuration:

```bash
oc create secret -n "$NAMESPACE" generic git-ssh-key \
  --from-file=dwo_ssh_key="$SSH_KEY" \
  --from-file=dwo_ssh_key.pub="$SSH_PUB_KEY" \
  --from-file=ssh_config=/tmp/ssh_config
```

3. Annotate the secret to configure it to be automatically mounted to your web terminal. **Note:** only web terminals created in the same namespace as your secret will have the SSH key and related data mounted.

```bash
kubectl patch secret -n "$NAMESPACE" git-ssh-key --type merge -p \
  '{
    "metadata": {
      "labels": {
        "controller.devfile.io/mount-to-devworkspace": "true",
        "controller.devfile.io/watch-secret": "true"
      },
      "annotations": {
        "controller.devfile.io/mount-path": "/etc/ssh/",
        "controller.devfile.io/mount-as": "subpath"
      }
    }
  }'
```

This will mount the files in the `git-ssh-key` secret to `/etc/ssh/`, creating files `/etc/ssh/wto_ssh_key`, `/etc/ssh/wto_ssh_key.pub` and overwrite file `/etc/ssh/ssh_config` with the file created in step 1.