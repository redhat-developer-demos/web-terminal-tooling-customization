# Creating & managing pods from within a Web Terminal
The Dockerfile in this directory creates an image with [kubedock](https://github.com/joyrex2001/kubedock) installed for use in Web Terminal. Kubedock allows for running containers on your cluster from within a web terminal pod.

For example, from within your web terminal you can run

```bash
podman run fedora:40 echo "hello world!"
```

And a pod running the fedora:40 image will be created in the project (namespace) you have configured with `oc` in your web terminal.

## Usage

In order to enable kubedock, the `$KUBEDOCK_ENABLED` environment variable must be set to `true` and the images entrypoint must be run. The Dockerfile provided in this directory already has `KUBEDOCK_ENABLED` set to true and the entrypoint is run upon starting the web terminal.

With kubedock enabled, running certain `podman` commands will result in them being passed to `kubedock` instead.

The following `podman` commands are run with kubedock, instead of `podman`:
- `run`
- `ps`
- `exec`
- `cp`
- `logs`
- `inspect`
- `kill`
- `rm`
- `wait`
- `stop`
- `start`

## Screenshots
#TODO: !

## Build & Push Instructions

Configure the following environment variables to point to your username in your container registry:
```bash
export REGISTRY=<your container registry> 
export USER=<your registry's username>
```

With [podman](https://github.com/containers/podman):
```bash
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:kubedock
podman push "${REGISTRY}"/${USER}/wto-tooling:kubedock
```

With docker:
```bash
docker build . -t "${REGISTRY}"/${USER}/wto-tooling:kubedock
docker push "${REGISTRY}"/${USER}/wto-tooling:kubedock
```

### Example

```bash
export REGISTRY="quay.io"
export USER="aobuchow"
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:kubedock
podman push "${REGISTRY}"/${USER}/wto-tooling:kubedock
```


