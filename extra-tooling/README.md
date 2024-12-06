# Extra Tooling for Web Terminal
The Dockerfile in this directory creates an image with some additional tooling for use in Web Terminal. 

## Included Tools

- [k9s](https://github.com/derailed/k9sbat)
- [bat](https://github.com/sharkdp/bat)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [lf](https://github.com/gokcehan/lf)

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
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
podman push "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
```

With docker:
```bash
docker build . -t "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
docker push "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
```

### Example

```bash
export REGISTRY="quay.io"
export USER="aobuchow"
podman build . -t "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
podman push "${REGISTRY}"/${USER}/wto-tooling:extra-tooling
```
