#!/bin/bash
set -euo pipefail

# Define an array with the hostnames and their corresponding IP addresses
declare -A hosts
hosts=(
  ["master1"]="10.17.4.21"
  ["master2"]="10.17.4.22"
  ["master3"]="10.17.4.23"
  ["worker1"]="10.17.4.24"
  ["worker2"]="10.17.4.25"
  ["worker3"]="10.17.4.26"
)

# SSH key path
SSH_KEY="/home/core/.ssh/id_rsa_key_cluster_openshift"

# Directories containing the certificates
CERT_DIR="/etc/kubernetes/pki"
ETCD_CERT_DIR="/etc/kubernetes/pki/etcd"

# Files to copy
CERT_FILES=(
  "ca.crt"
  "ca.key"
  "sa.pub"
  "sa.key"
  "apiserver.crt"
  "apiserver.key"
  "apiserver-kubelet-client.crt"
  "apiserver-kubelet-client.key"
)

ETCD_CERT_FILES=(
  "ca.crt"
  "ca.key"
  "etcd.crt"
  "etcd.key"
)

# Copy certificates to each host
for host in "${!hosts[@]}"; do
  ip=${hosts[$host]}
  echo "Copying certificates to $host ($ip)..."
  ssh -i "$SSH_KEY" core@$ip "sudo mkdir -p $CERT_DIR $ETCD_CERT_DIR"
  
  for file in "${CERT_FILES[@]}"; do
    scp -i "$SSH_KEY" "$CERT_DIR/$file" core@$ip:/tmp/
    ssh -i "$SSH_KEY" core@$ip "sudo mv /tmp/$file $CERT_DIR/$file"
  done
  
  for file in "${ETCD_CERT_FILES[@]}"; do
    scp -i "$SSH_KEY" "$ETCD_CERT_DIR/$file" core@$ip:/tmp/
    ssh -i "$SSH_KEY" core@$ip "sudo mv /tmp/$file $ETCD_CERT_DIR/$file"
  done
done

echo "Certificates copied successfully to all nodes."