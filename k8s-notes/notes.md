# Create gitlab Role

See: https://help.spotinst.com/hc/en-us/articles/360000226945-Creating-Kubernetes-Bearer-Token
- replace spotinst with gitlab

```
kubectl create -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: gitlab
  namespace: default
secrets:
- name: gitlab-secret
---
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-secret
  annotations:
    kubernetes.io/service-account.name: gitlab
type: kubernetes.io/service-account-token
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: gitlab-role
rules:
- apiGroups: [""]
  resources: ["pods", "nodes", "replicationcontrollers", "events", "limitranges", "services"]
  verbs: ["get", "delete", "list", "patch", "update"]
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: gitlab-role-binding
roleRef:
  kind: ClusterRole
  name: gitlab-role
  apiGroup: rbac.authorization.k8s.io
subjects:
- kind: ServiceAccount
  name: gitlab
  namespace: default
EOF
```

# Read the gitlab-secret token
kubectl describe secrets/gitlab-secret


# Create Namespaces

kubectl create -f - <<EOF
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "acme-dev",
    "labels": {
      "name": "acme-dev"
    }
  }
}
EOF


kubectl create -f - <<EOF
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "acme-test",
    "labels": {
      "name": "acme-test"
    }
  }
}
EOF


kubectl create -f - <<EOF
{
  "kind": "Namespace",
  "apiVersion": "v1",
  "metadata": {
    "name": "acme-prod",
    "labels": {
      "name": "acme-prod"
    }
  }
}
EOF



----


$ for i in {1..5}; do curl http://actuator:actuator@hazelcast.demo.tdlabs.k8s && echo ; done
{"node":"10.47.0.3"}
{"node":"10.40.0.5"}
{"node":"10.44.0.4"}
{"node":"10.47.0.3"}
{"node":"10.40.0.5"}


----

curl demo-api.demo.tdlabs.k8s/api/calc\?x=2\&\y=3

curl demo-app.demo.tdlabs.k8s/calc\?x=2\&\y=3
curl demo-app.demo.tdlabs.k8s/services