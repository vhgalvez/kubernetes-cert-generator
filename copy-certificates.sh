#!/bin/bash

# Define directories
IGNITION_DIR="/home/core/okd-install"
CERTS_DIR="/etc/kubernetes/pki"
ETCD_CERTS_DIR="/etc/kubernetes/pki/etcd"
SSH_KEY="/home/core/.ssh/id_rsa_key_cluster_openshift"

# Define hosts and their IPs
declare -A hosts
hosts=(
  ["master1"]="10.17.4.21"
  ["master2"]="10.17.4.22"
  ["master3"]="10.17.4.23"
  ["worker1"]="10.17.4.24"
  ["worker2"]="10.17.4.25"
  ["worker3"]="10.17.4.26"
)

# Verify existence of ignition files
FILES=("bootstrap.ign" "master.ign" "worker.ign")
for file in "${FILES[@]}"; do
  if [[ ! -f "$IGNITION_DIR/$file" ]]; then
    echo "Error: $IGNITION_DIR/$file not found. Ensure the ignition files are generated correctly."
    exit 1
  fi
done

# Copy ignition files to corresponding hosts
for host in "${!hosts[@]}"; do
  ip=${hosts[$host]}
  if [[ $host == master* ]]; then
    ignition_file="master.ign"
  else
    ignition_file="worker.ign"
  fi
  echo "Creating directory and copying $ignition_file to $host ($ip)..."
  ssh -i "$SSH_KEY" core@$ip "sudo mkdir -p /opt/openshift/ && sudo rm -f /opt/openshift/$ignition_file"
  scp -i "$SSH_KEY" "$IGNITION_DIR/$ignition_file" core@$ip:/tmp/$ignition_file
  ssh -i "$SSH_KEY" core@$ip "sudo mv /tmp/$ignition_file /opt/openshift/$ignition_file"
done

# Copy bootstrap.ign to the bootstrap node
echo "Copying bootstrap.ign to /opt/openshift/ on the bootstrap node..."
sudo mkdir -p /opt/openshift/
sudo cp /home/core/okd-install/bootstrap.ign /opt/openshift/

# Copy certificates to master and worker nodes
for host in "${!hosts[@]}"; do
  ip=${hosts[$host]}
  echo "Copying certificates to $host ($ip)..."
  scp -i "$SSH_KEY" -r $CERTS_DIR core@$ip:/tmp/
  ssh -i "$SSH_KEY" core@$ip "sudo cp -r /tmp/pki/* /etc/kubernetes/pki/ && sudo rm -rf /tmp/pki"
done
