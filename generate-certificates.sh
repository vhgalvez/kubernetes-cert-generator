#!/bin/bash
set -euo pipefail

# Crear directorios necesarios
sudo mkdir -p /etc/kubernetes/pki/etcd

# Generar CA
sudo openssl genrsa -out /etc/kubernetes/pki/ca.key 2048
sudo openssl req -x509 -new -nodes -key /etc/kubernetes/pki/ca.key -subj "/CN=kube-ca" -days 10000 -out /etc/kubernetes/pki/ca.crt

# Generar certificados y claves para etcd
sudo openssl genrsa -out /etc/kubernetes/pki/etcd/ca.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/etcd/ca.key -subj "/CN=etcd-ca" -out /etc/kubernetes/pki/etcd/ca.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/ca.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/etcd/ca.crt -days 10000

# Generar certificados y claves del API Server
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver.key -subj "/CN=kube-apiserver" -out /etc/kubernetes/pki/apiserver.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver.crt -days 10000

# Generar certificados y claves del cliente etcd
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-etcd-client.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-etcd-client.key -subj "/CN=etcd-client" -out /etc/kubernetes/pki/apiserver-etcd-client.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-etcd-client.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-etcd-client.crt -days 10000

# Generar certificados y claves del cliente kubelet
sudo openssl genrsa -out /etc/kubernetes/pki/apiserver-kubelet-client.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/apiserver-kubelet-client.key -subj "/CN=kubelet-client" -out /etc/kubernetes/pki/apiserver-kubelet-client.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/apiserver-kubelet-client.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /etc/kubernetes/pki/apiserver-kubelet-client.crt -days 10000

# Generar claves de servicio de cuenta
sudo openssl genrsa -out /etc/kubernetes/pki/sa.key 2048
sudo openssl rsa -in /etc/kubernetes/pki/sa.key -pubout -out /etc/kubernetes/pki/sa.pub

# Generar certificados y claves de etcd
sudo openssl genrsa -out /etc/kubernetes/pki/etcd/etcd.key 2048
sudo openssl req -new -key /etc/kubernetes/pki/etcd/etcd.key -subj "/CN=etcd" -out /etc/kubernetes/pki/etcd/etcd.csr
sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/etcd.csr -CA /etc/kubernetes/pki/etcd/ca.crt -CAkey /etc/kubernetes/pki/etcd/ca.key -CAcreateserial -out /etc/kubernetes/pki/etcd/etcd.crt -days 10000

# Asignar permisos
sudo chmod 600 /etc/kubernetes/pki/*.key
sudo chmod 644 /etc/kubernetes/pki/*.crt
sudo chmod 600 /etc/kubernetes/pki/etcd/*.key
sudo chmod 644 /etc/kubernetes/pki/etcd/*.crt
sudo chmod 644 /etc/kubernetes/pki/etcd/*.csr
sudo chmod 644 /etc/kubernetes/pki/etcd/etcd.crt
sudo chmod 644 /etc/kubernetes/pki/etcd/etcd.key

echo "Certificados generados y permisos asignados correctamente."