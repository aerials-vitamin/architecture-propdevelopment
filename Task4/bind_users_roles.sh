#!/bin/bash


kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: readonly-viewers-binding
subjects:
- kind: Group
  name: bi-analysts
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: readonly-viewer
  apiGroup: rbac.authorization.k8s.io
EOF
echo "ClusterRoleBinding 'readonly-viewers-binding' created."


kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cluster-configurators-binding
subjects:
- kind: Group
  name: operations
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-configurator
  apiGroup: rbac.authorization.k8s.io
EOF
echo "ClusterRoleBinding 'cluster-configurators-binding' created."


kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: security-auditors-binding
subjects:
- kind: Group
  name: security-specialists
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: security-auditor
  apiGroup: rbac.authorization.k8s.io
EOF
echo "ClusterRoleBinding 'security-auditors-binding' created."


kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developers-binding
  namespace: develope
subjects:
- kind: Group
  name: developers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole # Используем ClusterRole как шаблон
  name: developer-role-template
  apiGroup: rbac.authorization.k8s.io
EOF
echo "RoleBinding 'developers-binding' created in namespace 'develope'."
