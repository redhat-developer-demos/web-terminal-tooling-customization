#!/bin/bash

file_path=""
name=""
namespace=""
mount_path="/home/user/"  # Default mount path
verbose=false


usage() {
    cat <<EOF
Usage: $0 -p <file_path> --name <configmap_name> --namespace <namespace> [-mp <mount_path>] [-v, --verbose]

Arguments:
  -p, --path <file_path>
    The path to the file whose contents will be added to the ConfigMap.
  
  -n, --name <configmap_name>
    The name of the ConfigMap that will be created.

  -ns, --namespace <namespace>
    The namespace for the ConfigMap.

  -mp, --mount-path <mount_path> (Optional)
    The path where the file will be mounted in the ConfigMap's annotations.
    Default value: '/home/user/' if not provided.

  -v, --verbose (Optional)
    Enable verbose output (Print the generated ConfigMap to the console).
EOF
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--path)
            file_path="$2"
            shift 2
            ;;
        -n|--name)
            name="$2"
            shift 2
            ;;
        -ns|--namespace)
            namespace="$2"
            shift 2
            ;;
        -mp|--mount-path)
            mount_path="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        *)
            usage
            ;;
    esac
done


if [ -z "$file_path" ]; then
    echo "Error: -p <file_path> is required."
    usage
fi
if [ -z "$name" ]; then
    echo "Error: -n <name> is required."
    usage
fi
if [ -z "$namespace" ]; then
    echo "Error: -ns <namespace> is required."
    usage
fi


if [ ! -f "$file_path" ] || [ ! -s "$file_path" ]; then
    echo "Error: File '$file_path' is missing or empty."
    exit 1
fi


file_name=$(basename "$file_path")

configmap_filename="${file_name}-configmap.yaml"


cat <<EOF > "$configmap_filename"
kind: ConfigMap
apiVersion: v1
metadata:
  name: $name
  namespace: $namespace
  labels:
    controller.devfile.io/mount-to-devworkspace: 'true'
    controller.devfile.io/watch-configmap: 'true'
  annotations:
    controller.devfile.io/mount-as: subpath
    controller.devfile.io/mount-path: $mount_path
data:
EOF

# Append file's contents to the ConfigMap
echo "  $file_name: |" >> "$configmap_filename"
cat "$file_path" | sed 's/^/    /' >> "$configmap_filename"

# Print the ConfigMap to console if using --verbose
if $verbose; then
    cat "$configmap_filename"
fi

echo "ConfigMap created: $configmap_filename"
