#!/bin/bash


USER_NAME="user-bi-analysts-1"
USER_GROUP="bi-analysts"
OUTPUT_DIR="./user-creds-${USER_NAME}"
KUBECONFIG_FILE="${OUTPUT_DIR}/${USER_NAME}.kubeconfig"

MINIKUBE_DIR="${HOME}/.minikube"
CA_CERT="${MINIKUBE_CERTS_DIR}/ca.crt"
CA_KEY="${MINIKUBE_CERTS_DIR}/ca.key"


mkdir -p "${OUTPUT_DIR}"
echo "Создана директория для учетных данных: ${OUTPUT_DIR}"

openssl genrsa -out "${OUTPUT_DIR}/${USER_NAME}.key" 2048
echo "Сгенерирован приватный ключ: ${OUTPUT_DIR}/${USER_NAME}.key"


openssl req -new -key "${OUTPUT_DIR}/${USER_NAME}.key" -out "${OUTPUT_DIR}/${USER_NAME}.csr" -subj "/CN=${USER_NAME}/O=${USER_GROUP}"
echo "Создан CSR: ${OUTPUT_DIR}/${USER_NAME}.csr"

openssl x509 -req -in ${OUTPUT_DIR}/${USER_NAME}.csr -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out "${OUTPUT_DIR}/${USER_NAME}.crt" -days 365
echo "Сгенерирован сертификат: ${OUTPUT_DIR}/${USER_NAME}.crt"



echo "Generating Kubeconfig File"


CURRENT_CONTEXT=$(kubectl config current-context)

CLUSTER_NAME=$(kubectl config view -o jsonpath="{.contexts[?(@.name==\"${CURRENT_CONTEXT}\")].context.cluster}")

SERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name==\"${CLUSTER_NAME}\")].cluster.server}")


touch "${KUBECONFIG_FILE}"

kubectl config set-cluster "${CLUSTER_NAME}" \
  --kubeconfig="${KUBECONFIG_FILE}" \
  --server="${SERVER}" \
  --certificate-authority="${CA_CERT}" \
  --embed-certs=true

kubectl config set-credentials "${USER_NAME}" \
  --kubeconfig="${KUBECONFIG_FILE}" \
  --client-key="${OUTPUT_DIR}/${USER_NAME}.key" \
  --client-certificate="${OUTPUT_DIR}/${USER_NAME}.crt" \
  --embed-certs=true

CONTEXT_NAME="${USER_NAME}@${CLUSTER_NAME}"
kubectl config set-context "${CONTEXT_NAME}" \
  --kubeconfig="${KUBECONFIG_FILE}" \
  --cluster="${CLUSTER_NAME}" \
  --user="${USER_NAME}"

kubectl config use-context "${CONTEXT_NAME}" --kubeconfig="${KUBECONFIG_FILE}"

echo "${KUBECONFIG_FILE} successfully created"
