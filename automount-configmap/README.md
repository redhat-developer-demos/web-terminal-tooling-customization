# Mounting Configuration Files to a Web Terminal

## Using the configmap-creator Script

The `configmap-creator.sh` script (located in this directory) allows you to create a Kubernetes ConfigMap that will automatically mount configuration files, such as your `.zshrc`, to your web terminal in the namespace of your choice.

## Usage

```bash
./configmap-creator.sh -p <file_path> --name <configmap_name> --namespace <namespace> [-mp <mount_path>] [-v]
```

#### Arguments

- **`-p, --path <file_path>`**
  The path to the file whose contents will be added to the ConfigMap.

- **`-n, --name <configmap_name>`**
  The name of the ConfigMap that will be created.

- **`-ns, --namespace <namespace>`**
  The namespace for the ConfigMap.
  Note: Only web terminals created in the same namespace as the ConfigMap will have access to the mounted file.

- **`-mp, --mount-path <mount_path>`** (Optional)
  The path where the file will be mounted in the web terminal. Defaults to /home/user/.

- **`-v, --verbose`** (Optional)
  Enable verbose output. Prints the generated ConfigMap YAML to the console.

### Example

Here's an example on how to use the script:

```bash
./configmap-creator.sh -p ~/.zshrc --name zshrc-configmap --namespace aobuchow-dev --mount-path /home/user/ -v
```

This command will generate a ConfigMap named `zshrc-configmap.yaml` with the following:

- The contents of `~/.zshrc`, in a file named `.zshrc`
- The `metadata.name` being `zshrc-configmap`
- The namespace being `aobuchow-dev`
- Metadata and annotations that enable automatic mounting of the file `.zshrc` to the specified path `/home/user/`. The resulting file in the web terminal will be `/home/user/.zshrc`.

Once the generated `zshrc-configmap.yaml` ConfigMap is created, you can apply it to your cluster with:
```bash
oc apply -f ./zshrc-configmap.yaml
```

The ConfigMap will be created in the specified namespace (`aobuchow-dev` in this example).

Once applied, the file will be automatically mounted to your web terminal at the path specified in the `--mount-path` argument (or `/home/user/` by default) with the file having the same name as it had on your local filesystem. In this example, the resulting file in the web terminal will be `/home/user/.zshrc`.

Once applied, the file will be automatically mounted to your web terminal under the directory specified in the `--mount-path` argument (or `/home/user/` by default). The mounted file will keep its original name from your local filesystem. For example, in this case, the file will appear in your web terminal as `/home/user/.zshrc`.