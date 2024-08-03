# Kubernetes Certificate Generator

This repository contains a script to generate Kubernetes certificates for etcd, kube-apiserver, and kubelet.

## Usage

To generate the certificates, run the following command:

```bash
./generate-certificates.sh
```

Installation


Clone the repository to your local machine:


```bash
git clone https://github.com/tu-usuario/kubernetes-cert-generator.git
cd kubernetes-cert-generator
chmod +x generate-certificates.sh
```

## Certificates Generated

The script generates the following certificates and keys:

- CA certificate and key
- etcd CA certificate and key
- etcd server certificate and key
- kube-apiserver certificate and key
- kube-apiserver etcd client certificate and key
- kube-apiserver kubelet client certificate and key
- Service account key pair

## Directory Structure

The generated certificates and keys are stored in the following directories:

- `/etc/kubernetes/pki/`
- `/etc/kubernetes/pki/etcd/`

## Script Details

The script performs the following steps:

1. Creates necessary directories for storing the certificates.
2. Generates the CA certificate and key.
3. Generates the etcd CA certificate and key.
4. Generates the etcd server certificate and key.
5. Generates the kube-apiserver certificate and key.
6. Generates the kube-apiserver etcd client certificate and key.
7. Generates the kube-apiserver kubelet client certificate and key.
8. Generates the service account key pair.
9. Sets appropriate permissions on the generated files.

## Permissions

The script sets the following permissions on the generated files:

- `.key` files: 600
- `.crt` and `.csr` files: 644

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your changes.

## License

This project is licensed under the MIT License.
