# ZSH in Web Terminal
The Dockerfile in this directory builds an image with [ZSH](https://zsh.sourceforge.io/) installed for use in Web Terminal.

The image uses [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) to enhance ZSH with themes and plugins. It includes the [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) plugin as an example for installing ZSH plugins. You can learn more about Oh My Zsh [here](https://ohmyz.sh/).


## Setting `$SHELL` to ZSH

The `$SHELL` environment variable determines the default shell in your Web Terminal. You can configure this in one of two ways:

1. From within the Web Terminal Tooling image (as configured in this directory's `Dockerfile`).
2. By running the command `wtoctl set shell <shell-name>`.

To switch to ZSH using `wtoctl`, run:

```bash
wtoctl set shell <shell-name>
```
Upon running the above command, your web terminal will restart and you will be presented with ZSH.

## Mounting your .zshrc

You can customize ZSH by mounting your `.zshrc` into the Web Terminal using an [automount configmap](https://github.com/devfile/devworkspace-operator/blob/main/docs/additional-configuration.adoc#automatically-mounting-volumes-configmaps-and-secrets).


This repository provides the `configmap-creator.sh` script, which allows for easily creating an automount configmap that is populated with the data of your choosing, such as a `.zshrc` or any other configuration files. See [here](../automount-configmap/README.md) for instructions on how to use it.

If you'd like to manually create an automount configmap for your `.zshrc`, ensure the following:
1. The configmap exists in the same namespace as your web terminal.
2. The configmap contains the following labels and annotations:

```YAML
  labels:
    controller.devfile.io/mount-to-devworkspace: 'true'
    controller.devfile.io/watch-configmap: 'true'
  annotations:
    controller.devfile.io/mount-as: subpath
    controller.devfile.io/mount-path: <path>
```
Replace `<path>` with the desired file path of your `.zshrc`.

See [here](.zshrc-configmap.yaml) for an example of an automount configmap that mounts a `.zshrc`.

## Integrating Web Terminal's Default ZSH configuration

The Web Terminal Tooling image includes a [default ZSH configuration](https://github.com/redhat-developer/web-terminal-tooling/blob/main/etc/initial_config/.zshrc) that provides:
- Autocompletion for default tools such as oc, tkn, kn and more.
- A helpful terminal startup message
- As well as other defaults.

To make use of the default Web Terminal ZSH configuration, ensure your `.zshrc` begins with the following line:

```bash
source /tmp/initial_config/.zshrc
```

For an example of a custom `.zshrc` configuration, check [here](.zshrc)


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
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:zsh
podman push "${REGISTRY}"/${USER}/wto-tooling:zsh
```

With docker:
```bash
docker build . -t "${REGISTRY}"/${USER}/wto-tooling:zsh
docker push "${REGISTRY}"/${USER}/wto-tooling:zsh
```

### Example

```bash
export REGISTRY="quay.io"
export USER="aobuchow"
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:zsh
podman push "${REGISTRY}"/${USER}/wto-tooling:zsh
```

