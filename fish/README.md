# Fish shell in Web Terminal
The Dockerfile in this directory creates an image with the [Fish](https://fishshell.com/) shell installed for use in Web Terminal.

## Usage
The `$SHELL` environment variable determines which shell will be used in your web terminal. This can be configured from within the Web Terminal Tooling image you use (as is the case for the Dockerfile in this directory), or by using `wtoctl set shell <shell-name>`.

If the `$SHELL` environment variable is not set, and Fish is installed in your Web Terminal Tooling image, you can run `wtoctl set shell fish` to use the Fish shell. Upon running the command, your web terminal will restart and you will be presented with the Fish shell.

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
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:fish
podman push "${REGISTRY}"/${USER}/wto-tooling:fish
```

With docker:
```bash
docker build . -t "${REGISTRY}"/${USER}/wto-tooling:fish
docker push "${REGISTRY}"/${USER}/wto-tooling:fish
```

### Example

```bash
export REGISTRY="quay.io"
export USER="aobuchow"
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:fish
podman push "${REGISTRY}"/${USER}/wto-tooling:fish
```


