#!/bin/bash

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: readonly-viewer
rules:
- apiGroups: ["", "apps", "batch", "extensions", "networking.k8s.io", "storage.k8s.io"]
  resources: ["pods", "services", "deployments", "replicasets", "statefulsets", "daemonsets", "jobs", "cronjobs", "ingresses", "networkpolicies", "configmaps", "persistentvolumeclaims", "storageclasses", "nodes", "namespaces"]
  verbs: ["get", "list", "watch"]
EOF

echo "ClusterRole 'readonly-viewer' created."

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: developer-role-template
rules:
- apiGroups: ["", "apps", "batch", "extensions", "networking.k8s.io"]
  resources: ["pods", "services", "deployments", "replicasets", "statefulsets", "daemonsets", "jobs", "cronjobs", "ingresses", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["pods/log", "pods/exec"]
  verbs: ["get", "list", "create"] # Для отладки
EOF

echo "ClusterRole 'developer-role-template' created."

kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-configurator
rules:
- apiGroups: ["", "apps", "batch", "extensions", "networking.k8s.io", "storage.k8s.io", "rbac.authorization.k8s.io"]
  resources: ["pods", "services", "deployments", "replicasets", "statefulsets", "daemonsets", "jobs", "cronjobs", "ingresses", "networkpolicies", "configmaps", "persistentvolumeclaims", "storageclasses", "nodes", "namespaces", "roles", "rolebindings"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods/log", "pods/exec"]
  verbs: ["get", "list", "create"]
EOF

echo "ClusterRole 'cluster-configurator' created."


kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: security-auditor
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
EOF

echo "ClusterRole 'security-auditor' created."

